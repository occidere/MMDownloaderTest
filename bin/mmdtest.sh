# !/bin/bash


##### Environmental Variable #####
MARUMARU_HOME='/home/occidere/Marumaru'
MMD_TEST_HOME='/home/occidere/MMDownloaderTest'
MMD_JAR=${MMD_TEST_HOME}/bin/MMDownloader.jar

INPUT_PATH=${MMD_TEST_HOME}/input

today=$(date +%y%m%d_%H%M%S)

##### Functions #####
init(){
    mkdir -p ${INPUT_PATH}
}

make_test_list(){
    prefix='http://marumaru.in'
    update_list=$(curl -s 'http://marumaru.in' | grep /b/mangaup/.*title=\"\"\>.*\<)
    
    num=1

    for each in ${update_list}
    do
	if [[ $each = *"href"* ]];
	then
	    res=${each##href=\"\/}
	    url=${prefix}/${res%\"}
	    file_name=$(printf "d%02d.in" ${num}) # d=download

	    echo '1' > $INPUT_PATH/$file_name # single download
	    echo ${url} >> $INPUT_PATH/$file_name # archive url
	    echo '0' >> $INPUT_PATH/$file_name # exit program

	    ((num++))
	fi
    done
}

run_test(){
    for input in ${INPUT_PATH}/*.in
    do
	echo 'input: '${input}
	java -jar ${MMD_JAR} < ${input}
	echo ''
    done
}

delete_comics(){
    ls ${MARUMARU_HOME} | grep -ve .properties -ve log | xargs -t -I{} rm -rfv ${MARUMARU_HOME}/{}
}

main(){
    init
    make_test_list
    run_test
    delete_comics
}


##### main #####
main
