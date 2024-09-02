database -open -shm -into test_wave.shm test_wave -default -event
probe -create top_tb -depth all -all -database test_wave -waveform
probe -create $uvm:{uvm_test_top} -depth all -tasks -functions -all -database test_wave -waveform
run
