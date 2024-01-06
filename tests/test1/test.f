-uvm

-nowarn ILLDPX
-nowarn VARIST

../../sv/cdns_string_utils.sv
../../sv/cdns_vif_registry.sv

+uvm_set_severity=*,VIF-UNSET,UVM_WARNING,UVM_ERROR

tb_vif.sv
dut.sv
testbench_pkg.sv
tb.sv
