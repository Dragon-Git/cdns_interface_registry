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

// -*- binds an instance of the clk_intf into sub_block
// bind signals by name
bind sub_block clk_intf clk_intf_i(.*);
// by instance
//bind top_block.sub_block_i1 clk_intf clk_intf_i(.*);
//bind top_block.sub_block_i2 clk_intf clk_intf_i(.*);

// -*- just TB handling
module tb;
    import testbench_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class env extends uvm_test;
	    	`uvm_component_utils(env)
	    	
	    	virtual function void build_phase(uvm_phase phase);
		    		testbench tb1,tb2;
		    		super.build_phase(phase);
		    	       
		    	    tb1 = new("tb1",this);
       				tb2 = new("tb2",this);	
		    	
		    		uvm_config_db#(string)::set(tb2,"","HDLContext","sub_block_i2");		    	
       				uvm_config_db#(string)::set(tb1,"","HDLContext","sub_block_i1");
	    	endfunction
	    	
	    	function new (string name="", uvm_component parent);
		    	super.new(name,parent);
	    	endfunction
    endclass
    
    env mytop = new("env",null);
    
    initial begin
 
       // tell the TB component that its hdl paths are inside sub_block_i
       uvm_config_db#(string)::set(mytop,"","HDLContext","top_block");

       run_test();
    end
endmodule
