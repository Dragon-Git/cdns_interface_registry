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
// -*- an interface for DUT communication
interface clk_intf(output  bit clk);
	
   // -*- mandatory code
   // all interface instances will register itself with ~ifname~
   import cdns_vif_registry::*;
   function automatic void register();
      virtual clk_intf vif;
// the syntax to get a self reference to the enclosing interface is non-standard ieee1800-2012
// despite of that fact its supported by IUS,QUESTA,VCS just with a different syntax
// the issue itself is tracked as http://www.eda.org/mantis/view.php?id=4300
`ifdef INCA
      vif = clk_intf;
`endif
`ifdef VCS
      vif = ??? // clk_intf::self();
`endif
`ifdef QUESTA
      vif = ??? // clk_intf::self();
`endif
      
      cdns_vif_registry::cdns_vif_db#(virtual clk_intf)::register_vif(vif,$sformatf("%m"));
   endfunction
    
   initial register();
   // -*- mandatory code ends
endinterface 
