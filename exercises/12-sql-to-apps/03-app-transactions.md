# 03 — App transaction sketch

In plain English (or JS comments), outline transferring $10 from alice → bob:

1. Acquire a pool client  
2. BEGIN  
3. Debit / credit (parameterized)  
4. COMMIT or ROLLBACK  
5. Release client  

Why must all of that use the **same** client, not `pool.query` each time?
