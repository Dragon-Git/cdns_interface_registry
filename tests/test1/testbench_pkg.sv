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
`include "uvm_macros.svh"
package testbench_pkg;

   import uvm_pkg::*;
   import cdns_vif_registry::*;

class testbench extends uvm_env;
   // -*- this is a container private virtual interface
   virtual clk_intf vif;
   
   // Good ole uvm automation
   `uvm_component_utils(testbench)

   // Constructor
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction

   function void build();
      super.build(); 
      cdns_vif_registry::cdns_vif_db#(virtual clk_intf)::retrieve_vif(vif,this,"clk_intf_i");
   endfunction
   
   task run_phase(uvm_phase phase);     
      phase.raise_objection(this);
      #3;
      vif.clk <= 0;
      repeat(100) begin
         #10 vif.clk <= !vif.clk;
      end
      
      phase.drop_objection(this);
   endtask
endclass
endpackage
