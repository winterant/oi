{
TASK :STRING
LANG : PASCAL
}
Uses oracle;

begin
    start_string;
    oracle_call('ATGC');
//    oracle_call('');
    answer_string('ATTGCGCGATCG');
end.
