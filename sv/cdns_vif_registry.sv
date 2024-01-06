/*
 //------------------------------------------------------------
 //   Copyright 2014-2015 Cadence Design
 //   All Rights Reserved Worldwide
 //
 //   Licensed under the Apache License, Version 2.0 (the
 //   "License"); you may not use this file except in
 //   compliance with the License.  You may obtain a copy of
 //   the License at
 //
 //       http://www.apache.org/licenses/LICENSE-2.0
 //
 //   Unless required by applicable law or agreed to in
 //   writing, software distributed under the License is
 //   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 //   CONDITIONS OF ANY KIND, either express or implied.  See
 //   the License for the specific language governing
 //   permissions and limitations under the License.
 //------------------------------------------------------------

 mailto: uwes@cadence.com

 name: an interface registry

 it allows the following

 1. interface instances can register automatically themselves in a database with their full %m paths as key
 2. users can retrieve the vif instance if the know the right key
 3. the lookup key is constructed via getHDLContext(uvm_component) which queries the string attribute of the component and its parents nd a custom postfix.
 4. the retrieved vif can be checked automatically for existence and non-null

 */
`include "uvm_macros.svh"

package cdns_vif_registry;
	import uvm_pkg::*;
	import cdns_string_utils::str_join;

   // for debug purposes
   typedef uvm_component uvm_component_queue_t[$];
   uvm_component_queue_t connectivity_map[string];

	class cdns_vif_db#(type T=int) extends uvm_config_db#(T);
		// a catcher to silence the regex warning message in uvm12
		class noregex_catcher extends uvm_report_catcher;
			local bit is_enabled = 0;
			function new(string name);
				super.new(name);
				uvm_report_cb::add(null,this);
			endfunction

			virtual function action_e catch();
				if((get_id() == "UVM/RSRC/NOREGEX") && is_enabled) return CAUGHT;
				return THROW;
			endfunction // catch
			virtual function void set_enabled(bit v);
				is_enabled=v;
			endfunction
		endclass
		static noregex_catcher my_noregex_catcher = new("CDNS-NOREGEX");

		// removes the "register" scope path component from the instance path
		// essentially returns the interfaces parent vlog instance path
		static local function string fixname(string name);
			string    q[$];
			int   qi[$];
			uvm_split_string(name, ".", q);
			qi = q.find_last_index(s) with (s== "register");
			if(qi.size() > 0)
				q.delete(qi[0]);
			return str_join(".",q);
		endfunction

		// registers the ~vif~ under "vifs" with a fieldName ~vifName~
		static function void register_vif(T vif, string vifName);
			string    n = fixname(vifName);
			`uvm_info("VIF-SELF-REGISTER",$sformatf("vif \"%p\" registered with key=%s",vif,n),UVM_NONE)
			my_noregex_catcher.set_enabled(1);
			set(null,"vifs",n,vif);
			my_noregex_catcher.set_enabled(0);
		endfunction

		// retrieves the full HDLContext of ~cntxt~
		static function string getHDLContext(uvm_component cntxt);
			string    q[$];
			while(cntxt!=null) begin
				string s;
				if(uvm_config_db#(string)::get(cntxt,"","HDLContext",s))
					q.push_front(s);

				cntxt=cntxt.get_parent();
			end
			return str_join(".",q);
		endfunction

		// retrieves a ~vif~ stored at <cntxt-path>.<path>
		// it will be validated when ~validated~ is set to 1 (non-null vif assigned)
		static function void retrieve_vif(ref T vif,input uvm_component cntxt,string path, bit validate=1);
			string    n = getHDLContext(cntxt);
			string    fn = {n,".",path};
			if(get(null,"vifs",fn,vif)) begin
				if(vif==null && validate)
					`uvm_warning("VIF-NULL", $sformatf("vif is null retrieving component=%s HDLContext=%s name=%s",
							cntxt.get_full_name(),n,path))
			end
			else
				if(validate)
					`uvm_warning("VIF-UNSET",$sformatf("vif not found for component=%s HDLContext=%s path=%s",
							cntxt.get_full_name(),n,path))

			`uvm_info("VIF-SETUP",$sformatf("using vif \"%p\" from HDLContext=%s and path=%s in component=%s",
					vif,n,path,cntxt.get_full_name()),UVM_MEDIUM)

		      connectivity_map[fn].push_back(cntxt);
		endfunction
	endclass
endpackage
