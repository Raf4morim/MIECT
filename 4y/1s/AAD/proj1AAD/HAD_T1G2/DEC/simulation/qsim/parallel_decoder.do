onerror {exit -code 1}
vlib work
vcom -work work parallel_decoder.vho
vcom -work work full_sim_2.vwf.vht
vsim -c -t 1ps -L cycloneiv -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.full_parallel_decoder_vhd_vec_tst
vcd file -direction parallel_decoder.msim.vcd
vcd add -internal full_parallel_decoder_vhd_vec_tst/*
vcd add -internal full_parallel_decoder_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f
