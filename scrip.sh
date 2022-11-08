!/usr/bin/bash
sed 1d CCrec.csv >> CreditcardRecord.csv
mv CreditcardRecord.csv CCrec.csv
fil=CCrec.csv  #loading the file data 
while IFS= read -r line
do
  Card_Type_Code="$(echo "$line" | cut -d "," -f 1 )"
  Card_Type_Full_Name=$(echo "$line" | cut -d "," -f 2 )
  Issuing_Bank=$(echo "$line" | cut -d "," -f 3 )
  cnum=$(echo "$line" | cut -d "," -f 4 ) 
  Card_Holder_Name=$(echo "$line" | cut -d "," -f 5 )
  CVV_CVV2=$(echo "$line" | cut -d "," -f 6 )
  Issue_Date=$(echo "$line" | cut -d "," -f 7 )
  carddate=$(echo "$line" | cut -d "," -f 8 )
  Billing_Date=$(echo "$line" | cut -d "," -f 9 )
  Card_PIN=$(echo "$line" | cut -d "," -f 10 )
  Credit_Limit=$(echo "$line" | cut -d "," -f 11 )
  Credit_Lim=$(echo "$Credit_Limit" | awk '{printf "$%.0f\n",$1}' )

  ## making directories based on  card type full name :
  if [ ! -d "outp/$Card_Type_Full_Name" ]
  then
      mkdir "outp/$Card_Type_Full_Name"
  # else
  #     echo "File exists"
  fi

  ## making sub directories based on  issuing bank :
  if [ ! -d "outp/$Card_Type_Full_Name/$Issuing_Bank" ]
  then
      mkdir "outp/$Card_Type_Full_Name/$Issuing_Bank"
  # else
  #     echo "File exists"
  fi
  
  ## checking if the card is expired or not 
  f ="expired"
  cardmon=$(echo ${carddate%/*})
  cardyear=$(echo ${carddate#*/})
  curyear=$(echo $(date +'%Y'))
  curmon=$(echo $(date +'%m'))

  if [ $curyear -gt $cardyear ]
    then 
    f="expired"
  else
    if [ $cardyear -gt $curyear ]
       then
       f="active"
    else
      if [ $cardmon -ge $curmon ]
         then
         f="active"
      else 
         f="expired"
      fi
    fi
  fi 
  
  # formating data in the file
  echo " " >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"   
  echo "Card Type Code: $Card_Type_Code" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Card Type Full Name: $Card_Type_Full_Name" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Issuing Bank: $Issuing_Bank" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Card Number: $cnum" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Card Holders Name: $Card_Holder_Name" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "CVV/CVV2: $CVV_CVV2" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Issue Date: $Issue_Date" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Expiry Date: $carddate" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Billing Date: $Billing_Date" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Card PIN: $Card_PIN" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
  echo "Credit Limit: $Credit_Lim USD" >> "outp/$Card_Type_Full_Name/$Issuing_Bank/$cnum"."$f.txt"
done < "$fil"

#storing back all the files data into a single file.
printf "Card Type Code,Card Type Full Name,Issuing Bank,Card Number,Card Holder's Name,CVV/CVV2,Issue Date,Expiry Date,Billing Date,Card PIN,Credit Limit" >> RecoveredCC_records.csv
for dire in outp/*
do 
  for subdire in "$dire"/*
  do
    for filess in "$subdire"/*
    do
      while IFS= read -r line
      do 
        kkk="$(echo $( sed -n -e 's/^.*: //p'))"
      done < "$filess"
      echo "$kkk" >> RecoveredCC_records.csv
    done
  done
done

sed 's/[$,]//g' RecoveredCC_records.csv >> CCr_updated.csv
mv CCr_updated.csv  RecoveredCC_records.csv

sed 's/[USD,]//g' RecoveredCC_records.csv >> CCr_updated2.csv
mv CCr_updated2.csv  RecoveredCC_records.csv




