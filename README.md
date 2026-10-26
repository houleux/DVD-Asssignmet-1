# 4-bit Array Multiplier — RTL to GDSII

Team members:
- Sai Rithvik Achutuni, 2023102060
- Gautam Gandhi, 2023102059

## Commands run (in order)

<!-- Record the exact command you ran for every step, in order, as you go. -->

### Part A — RTL design and verification

```
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v
vvp sim
gtkwave mult.vcd
```

Task 6 (error-catching check — edit `rtl/full_adder.v` so `sum = a ^ b` (drop `cin`), rerun, then revert):

```
iverilog -g2012 -o sim tb/tb_mult.v rtl/full_adder.v rtl/mult_array.v
vvp sim
```

### Part B — Logic synthesis

```
yosys -c synth/synth.tcl
```

Gate-level simulation of the synthesized netlist:

```
CELLS=$PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/verilog
iverilog -g2012 -DFUNCTIONAL -DUNIT_DELAY=#1 -o gls \
    tb/tb_mult.v $CELLS/primitives.v $CELLS/sky130_fd_sc_hd.v synth/mult_array_netlist.v
vvp gls
```

### Part C — Static timing analysis

```
sta sta/sta.tcl          # first run, T=10 in sta.tcl, to get worst slack (WNS)
```

Edited `sta.tcl` to set `T 2.60` (= 10 − WNS), then:

```
sta sta/sta.tcl          # confirms slack ≈ 0 at T_min
```

### Part D — Physical design

```
cd pnr
librelane config.json    # CLOCK_PERIOD=3.5  -> setup FAIL
librelane config.json    # CLOCK_PERIOD=4.0  -> setup FAIL
librelane config.json    # CLOCK_PERIOD=6.0  -> setup FAIL
librelane config.json    # CLOCK_PERIOD=6.5  -> setup FAIL
librelane config.json    # CLOCK_PERIOD=7.0  -> PASS (0 DRC, 0 LVS, slack ≥ 0)
cp runs/<final_run>/final/metrics.json metrics.json
cp runs/<final_run>/final/gds/mult_array.gds mult_array.gds
```
