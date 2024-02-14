## Run API and scripts 

> Run WAHA (WhatsApp HTTP API) - CORE version
1. Execute the following command in your terminal:
```bash
sudo docker run -it -p 3000:3000/tcp devlikeapro/whatsapp-http-api
```
2. Open the provided link.

3. Click on POST -> /api/sessions/start -> try it out -> Execute.

> On the same page, scroll down to the screenshot section.

4. Click on GET -> /api/screenshot -> try it out -> Execute.

> Pairing the Device with Your Phone (similar to WhatsApp Web):

> When it shows as associated with Mac OS on your phone, go back and click execute again.

> Navigate to the 'TPR/Proj/wpp_sms' directory

5. Execute the following commands in your terminal:

```bash
python sequential.py
python smart.py
```