'''
1. From the datasets in the Data folder, select one dataset and find association 
rules in it (minimum 30 rules). Give an interpretation of the rule with the highest 
support value.

'''

# I have selected the dataset groceries.csv

groceries.tr<-read.transactions(file = "groceries.csv", format = "basket", 
                        sep = ",", header = T, 
                        rm.duplicates = FALSE,
                        quote = "", skip = 0,
                        encoding = "unknown")

# We are going to set support = 0.01 and confidence = 0.4

rules <- apriori(groceries.tr, parameter = list(supp = 0.01, conf = 0.4, maxlen = 4))

# We use summary to check how many rules we have (we need at least 30).
# In this case, we have 62

summary(rules)

# Now we sort the rules by support on a decreasing sense

rules.sort <- sort(rules, by="support", decreasing=TRUE)
inspect(rules.sort[1])

'''
 lhs         rhs          support confidence
[1] {yogurt} => {whole milk} 0.056   0.4       
    coverage lift count
[1] 0.14     1.6  551  

This means that 5.6% of transactions have yogurt and whole milk at the
same time. This also means that in 40% of transactions where yogurt has
been bought, whole milk has also been bought

2. Select one item from the collection and find the rules in which the 
selected item is rhs. Give an interpretation of the rule with the highest 
confidence value.

'''
rulesChocolate <- apriori(groceries.tr,
                          parameter = list(support=0.01, confidence=0.01),
                          appearance = list(rhs = c("chocolate"), default="lhs"))

rulesChocolate.sort <- sort(rulesChocolate, by="confidence", decreasing = TRUE)
inspect(rulesChocolate.sort[1])

'''
    lhs       rhs         support confidence
[1] {soda} => {chocolate} 0.014   0.078     
    coverage lift count
[1] 0.17     1.6  133  

This means that 1.4% of all transactions have both items (chocolate and soda).
This also means that in 7.8% of transactions where we have soda, there is 
chocolate too.

3. Select one of the items from the set (different from the item in subsection 2) 
and find the rules in which the selected item is lhs. Write the resulting rules 
into the data frame.

'''

rulesMilk <- apriori(groceries.tr,
                     parameter = list(support=0.1, confidence=0.1),
                     appearance = list(default="rhs",lhs = c("whole milk")))

write(rulesMilk, file = "rulesMilk.csv", quote=TRUE, sep = ",", col.names = NA)

'''

4. Find the frequentist sets in the selected dataset.

'''

freq.items <- apriori(groceries.tr, parameter = list(
  support = 0.01,
  minlen = 2,
  maxlen = 5,
  target = "frequent itemsets"))

''' 

In my case, I have selected itemsets that have between 2 and 5 items and appear
at least in 1% of the transactions

'''