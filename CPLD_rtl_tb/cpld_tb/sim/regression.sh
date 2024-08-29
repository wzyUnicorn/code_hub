TESTLIST=(
test_base
test_btn_power_on_off
test_btn_power_on_reset
test_btn_power_on_interrupt
test_btn_power_on_dcok
test_btn_power_on_alarm
test_btn_power_on_jitter
test_btn_power_on_again
test_iic_power_on_off
test_iic_power_on_reset
test_iic_power_on_mtrst
test_iic_power_on_beep
test_lpc_power_off
test_lpc_soft_reset
test_lpc_mt_reset
test_lpc_vga
test_lpc_vga_disable
test_lpc_ich
test_lpc_beep
test_lpc_write_read
test_lpc_transfer_abort
test_btn_on_iic_reset
test_btn_on_iic_off
test_btn_on_iic_beep
test_btn_on_iic_random_addr
test_btn_on_tele_off
test_btn_on_tele_reset
test_iic_on_btn_reset
test_iic_on_btn_off
test_iic_on_lpc_reset
test_iic_on_lpc_mtrst
test_iic_on_lpc_off
test_iic_on_lpc_vga
test_iic_on_lpc_ich
test_iic_on_lpc_beep
test_iic_on_tele_reset
test_iic_on_tele_off
test_tele_on_off
test_tele_on_rst_off
test_tele_on_btn_off
test_tele_on_btn_reset
test_tele_on_iic_reset
test_tele_on_iic_off
test_tele_on_lpc_reset
test_tele_on_lpc_off
);
for i in ${TESTLIST[*]};
do
    echo "======================="
    echo RUN TEST=$i;
    echo "======================="
    make sim TEST=$i
done
make check_fatal
make merge_cov
echo TestCase Count = ${#TESTLIST[@]};

