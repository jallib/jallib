import smtplib, sys, os

from email.mime.text import MIMEText
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart

import japp_config

COMMASPACE = ', '

try:
    topublish = sys.argv[1]
except IndexError:
    print >> sys.stderr, "Please provide a readdy-to-publish directory"
    sys.exit(255)

title = file("%s/title" % topublish).read().strip()
content = file("%s/content" % topublish).read()
path = file("%s/path" % topublish).read()

# Create the container (outer) email message.
msg = MIMEMultipart('related')
msg['Subject'] = title
# me == the sender's email address
me = japp_config.FROM_ADDRESS
dest = japp_config.TO_ADDRESS
msg['From'] = me
msg['To'] = dest 

commands = """pass: %s
path: content/%s
uid: 3

""" % (japp_config.FROM_PASSWD,path)

txt = MIMEText(commands + content)
msg.attach(txt)

# Assume we know that the image files are all in PNG format
imgfiles = map(lambda x: os.path.join(topublish,x),[f for f in os.listdir(topublish) if not f in ['title','content','path']])
for img in imgfiles:
    # Open the files in binary mode.  Let the MIMEImage class automatically
    # guess the specific image type.
    fp = open(img, 'rb')
    imgm = MIMEImage(fp.read())
    imgm['Content-Disposition'] = 'attachment; filename="%s"' % os.path.basename(img)
    fp.close()
    msg.attach(imgm)

# Send the email via our own SMTP server.
s = smtplib.SMTP()
s.connect()
s.sendmail(me, dest, msg.as_string())
s.quit()

