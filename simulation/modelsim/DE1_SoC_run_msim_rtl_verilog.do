transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/userInput.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/DE1_SoC.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/meta.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/led_matrix_driver.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/greenPattern.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/LFSR_3bit.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/hexCount.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/topLight.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/hexDisplay.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/gameControl.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/realClock.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/centerLight.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/normalLight.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/redMovement.sv}
vlog -sv -work work +incdir+C:/Users/USER/Desktop/UW/courses/19\ SU/EE\ 271/Lab\ 6/Lab\ 6 {C:/Users/USER/Desktop/UW/courses/19 SU/EE 271/Lab 6/Lab 6/greenShifting.sv}

