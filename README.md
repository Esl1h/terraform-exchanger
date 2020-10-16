# terraform-exchanger
Um simples shell script para facilitar o uso do mesmo código terraform em vários ambientes. A simple shell script to facilitate the use of the same terraform code in many environments.



## Função:
Este script irá facilitar o uso do terraform em pequenos projetos em que não há necessidade de uso de ferramentas mais complexas.

Este shell é um simples facilitador, em projetos maiores (em qualquer sentido), recomendo o uso das workspaces, terragrunt, atlantis e outros, além de ferramentas para automação ci/cd...

Ele irá verificar sua versão atual, caso não tenha (ou não esteja no $PATH), ou seja outra versão, ele irá baixar e executar a informada na variavel $VERSION.

Antes de cada init, ele remove o diretório local .terraform/





## Uso:

informe como parametro o ambiente a ser executado: \"dev\", \"qa\" ou \"prod\"
 e informe o parametro do terraform: \"init\", \"plan\", \"apply\" ou "import". 
  
 

Exemplo:

<code>terraform dev init </code>   


Caso o parametro for \"import\", informe em sequência o resource e o ARN/ID/Name do recurso na AWS. 


Exemplo:

<code> terraform dev import "resource" "ARN"</code>