#!/bin/bash
PATH=$(pwd):$PATH
TERRAFORM=$(terraform -v | head -n 1)
VERSION="Terraform v0.13.4"
DOWNLOAD="https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip"
PACKAGE="terraform_0.13.4_linux_amd64.zip"
ENVIRONMENT=$1
TF_PARAM=$2
ENV_REGEX="^(qa$|dev$|prod$)"
TF_REGEX="^(init$|plan$|apply$|import$)"

yell() { 
    echo "$0: $*" >&2; 
    }
die() { 
    yell "$*"; exit 111; 
    }
try() { 
    "$@" || die "cannot $*"; 
    }


function erroarg() {
    echo "$0: $*" >&2;
    echo "Não há parametros dev|prod e init|plan|apply|import"
    echo "execute -h para mais informações"
    exit 1
}

function erroarg1() {
    echo "$0: $*" >&2;
    echo "o parametro \"$ENVIRONMENT\" está errado"
    echo "execute -h para mais informações"
    exit 1
}

function erroarg2() {
    echo "$0: $*" >&2;
    echo "o parametro \"$TF_PARAM\" para o terraform não é suportado por este programa"
    echo "execute -h para mais informações"
    exit 1
}

function helpinfo() {
    echo "$0: $*" >&2;
    echo -e "\a Terraform Script \n
            \v informe como parametro o ambiente a ser executado: \"dev\", \"qa\" ou \"prod\",  e informe o parametro do terraform: \"init\", \"plan\", \"apply\". Exemplo:\n
            # terraform dev init   
            \v Caso o parametro for \"import\", informe em sequencia o resource e o ARN/ID/Name do recurso na AWS. Exemplo:\n
            # terraform dev import "resource" "ARN"
            
            "
    exit 1
}

function install() {
        wget -c $DOWNLOAD && \
        unzip -o $PACKAGE && \
        rm $PACKAGE && \
        chmod +x terraform
        PATH=$(pwd):$PATH
        TERRAFORM=$(terraform -v | head -n 1)
}


if ! command -v terraform &> /dev/null
then
    install
fi

if [ "$TERRAFORM" == "$VERSION" ]; 
    then
        echo "$VERSION"
    else
        echo "$TERRAFORM"
        install
fi

if [ -z "$1" ]; 
    then 
        erroarg
    elif
        [ $1 == "--help" -o $1 == "-h" -o $1 == "-help" ]; then
        helpinfo
        die ;
    else
    echo "iniciando..."
fi

if [[ $ENVIRONMENT =~ $ENV_REGEX ]];
    then
        ENVM=$ENVIRONMENT
    else
        erroarg1
        exit 1
fi 

if [[ $TF_PARAM =~ $TF_REGEX ]];
    then
        TFARG=$TF_PARAM
    else
        erroarg2
        exit 1
fi 


if [ $TFARG == "init" ];
    then
        rm -rf .terraform/
        terraform $TFARG --backend-config=$ENVM.backend.tfvars --var-file=$ENVM.tfvars
    elif [ $TFARG == "plan" ];
    then
        terraform $TFARG --var-file=$ENVM.tfvars -out=tf.plan -input=false
    elif [ $TFARG == "apply" ];
    then
        terraform $TFARG --var-file=$ENVM.tfvars -input=false tf.plan -auto-approve
    elif [ $TFARG == "import" ];
        then
        terraform $TFARG --var-file=$ENVM.tfvars $3 $4
    else
        try
fi 

