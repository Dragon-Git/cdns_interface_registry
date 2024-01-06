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
// bind signals by name
bind sub_block clk_intf clk_intf_i(.*);

// by instance
bind top_block clk_intf clk_intf_i(.clk(tb.tb_clk));
//bind top_block.sub_block_i2 clk_intf clk_intf_i(.*);

// -*- just TB handling
module tb;
    import testbench_pkg::*;
    import uvm_pkg::*;
    bit tb_clk ;
    initial begin
       top_testbench top_testbench_i= new("top_testbench_i",null);

       uvm_config_db#(string)::set(uvm_root::get(),"top_testbench_i","HDLContext","top_block");
       run_test();
    end
endmodule
