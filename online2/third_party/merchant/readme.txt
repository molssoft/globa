1. Go to https://secureshop-test.firstdata.lv/report/ -> KeyStore and download "*.pkcs12" file

2. Convert "*.pkcs12" file with command "openssl pkcs12 -in 1234567_imakstore_test.p12 > 1234567_imakstore_test.pem"

3. Edit "includes/config.php"

4. Go to https://secureshop-test.firstdata.lv/report/ -> Merchant -> Edit and change IP address, returnOkUrl, returnFailUrl

5. Open with your browser "index.php"

6. Meke DMS or SMS transactions, review transaction results in transaction list

7. You must pass Test Plan https://secureshop-test.firstdata.lv/report/ -> Test Plan. Select Case and do transaction. Enter results.



== Business Day Closing using Crontab ==

Edit and add this line to crontab:
0 0 * * *  php /var/www/html/test-shop/bd.php > /dev/null 2>&1


bd.php will execute every night at 00:00