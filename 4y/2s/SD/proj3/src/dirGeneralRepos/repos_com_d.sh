source config
CODEBASE="http://$rmi_name/"$1"/classes/"
java -Djava.rmi.server.codebase=$CODEBASE\
     -Djava.rmi.server.useCodebaseOnly=true\
     -Djava.security.policy=java.policy\
     serverSide.main.ServerGeneralRepos $generalRepos_port $rmi_name $rmi_port