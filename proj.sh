#!/bin/bash
<<Doc
Name:Bharath J
Date:
Description:
Input:
Output:
Doc
fvar=0
while [ $fvar -eq 0 ]    
do
    fvar=1
    echo "1 - signup"
    echo "2 - signin"
    echo "3 - exit"
    read -p "Enter the choice : " ch 
    flag=1 
    case $ch in 
	1)  
	    if [ -s user.csv ]
	    then
		while [ $flag -eq 1 ]
		do
		    read -p "Enter the user_name : " usrname	
		    
		    arruser=(`cat user.csv`)
		    n=${#arruser[@]}
		    for i in `seq 0 $((n- 1))`
		    do	
			if [ -z "$usrname" ]
			then
			    echo "Error : Enter proper user id"
			    break
			fi	
			if [ ${arruser[$i]} == $usrname ]
			then
			    echo "Error : The user_name already exist try again "
			    flag=1
			    break
			else
			    flag=0
			fi
		    done
		done
	    else
		em=0
		while [ $em -eq 0 ]
		do
		read -p "Enter the user_name : " usrname
			if [ -z "$usrname" ]
			then
			    echo "Error : Enter proper user id" 
			else
			    echo "$usrname" >> user.csv
			    echo "inserted"
			    em=1
			fi
	        done
	    fi	
	    if [ $flag -ne 1 ]
	    then 
		echo "$usrname" >> user.csv
	    fi
	    flag=1
	    while [ $flag -eq 1 ]
	    do
		read -s -p "Enter the password : " password
		echo 
		read -s -p "Confirm the password : " repassword
		if [ $repassword == $password ]
		then 
		    echo
		    echo "sign up successfully :) "
		    echo "$password" >> password.csv
		    flag=0
		else
		    echo 
		    echo "Error: Password doesnt match "
		fi
	    done
	    ;;
	2)    
	    function test()
	    {   
		var=0
		while [ $var -eq 0 ]
		do

		    echo "1. Take Test "
		    echo "2. Exit"
		    read -p "Which one would u like to take " op
		    case $op in
			1)  
			    total_lines=`cat questions.txt | wc -l`
			    n=0
			    count=0
			    for i in `seq 5 5 $total_lines`
			    do 
				head -$i questions.txt | tail -5

				for i in `seq 10 -1 1`
				do
				    echo -en "\r Enter the option : $i "
				    read  -t 1 option
				    if [ -n "$option" ]
				    then
					break
				    else
					option="e"
					
				    fi
				done
				echo "$option" >> answer.txt
				if [ $option == "e" ]
				then 
				    echo
				fi 
				echo
			    done
			    arr_ans=(`cat answer.txt`)
			    arr_crt_ans=(`cat checkanswer.txt`)
			    for i in `seq 5 5 $total_lines`
			    do 
				head -$i questions.txt | tail -5

				if [ ${arr_ans[$n]} = ${arr_crt_ans[$n]} ]
				then
				    echo -e "\e[1;42m Correct Answer\e[0m"
				    echo
				    count=$((count+1))
				elif [ $option == "e" ]
				then
				    echo -e "\e[1;41m Wrong Answer!! \e[0m"
				    echo "Correct answer is ${arr_crt_ans[$n]}"
				    echo "Your answer is $option"
				    echo
				else
				    echo -e "\e[1;41m Wrong Answer!! \e[0m"
				    echo "Correct answer is ${arr_crt_ans[$n]}"
				    echo "your answer is $option"
				    echo
				fi
				n=$((n+1))
			    done
			    echo "your total marks is $count/$((total_lines/5))"
			    var=1 
			    ;; 
			2)
			    echo "EXIT"
			    var=1
			    ;;
			*)
			    echo "enter valid option"
		    esac
		done
	    }

	function signin()
	{
	    u=0
	    while [ $u -eq 0 ]
	    do
		read -p "Enter the user name: " usrname
		arruser=(`cat user.csv`)
		l=${#arruser[@]}
		for i in `seq 0 $((l -1))`
		do   
			if [ -z "$usrname" ]
			then
			    echo "Error : Enter proper user id"
			    flag=0
                            break
                        else
                  #echo "${arruser[$i]}"
		    if [ $usrname == ${arruser[$i]} ]
		    then
			n=0
			flag=0
			while [ $n -eq 0 ]
			do  

			    read -sp "Enter the password : " password
			    arrpass=(`cat password.csv`)

			if [ -z "$password" ]
			then
			    echo "password doesnot match"
                        else

			    if [ $password == ${arrpass[$i]} ]
			    then
				echo "successfully loged in "
				test $op
				u=1
				n=1
			    else
				echo "Password doesnot match "
			    fi
			fi
			done
			break
		    else
			flag=1
		    fi
			fi
		done
		if [ $flag -eq 1 ]
		then
		    echo "User id doesnt exist!!! Enter a valid user id "
		fi
	    done
	    rm answer.txt
	    touch answer.txt
	}
    signin $usrname
    ;;
3)
    echo "successfull exit!!!!"
    ;;
*)
    echo "Error: Enter valid option"
    fvar=0
esac
done
