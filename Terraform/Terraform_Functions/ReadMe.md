-- Terrform functions plays a vital role in creating and managing terraform code effectively
--We will see some important functions in terraform, for more refer doc https://developer.hashicorp.com/terraform/language/functions

--**lower("STRINg")**
--**upper("string")**
--**count** : We need to provide how many iterations that block of code to be executed
--**count.index** : To get the index value(current iteration number)
--**list** : Group of items to be placed
--**element(list,index)** - it will get the individual items of the list based on index
--**length** : To find the length of list
--condition:  condition ? true_value : false_value
--**map**
--**lookup(map,key,default)**
--**dynamic-blocks** : when few lines of code reuired to excecute multiple times using dynamic blocks and for_each loop


**AMI ID's will be changed for every region**
# while working with the lists, we should not include any new item in the middle of it, it changes the entire index values. So we have to append(add to last)