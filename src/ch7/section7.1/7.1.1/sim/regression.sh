TESTLIST=(
my_case0
my_case1
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

