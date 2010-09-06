################################
# Main JAPP configuration file #
################################

# This is a python script, but this can also be
# used as a shell script :)


# DITA/Japp configuration
#------------------------

# Prefix path used to generated an absolute path
# with submitted filenames. Ex: if you submit
# "dirc/file.xml" and the absolute path is 
# "/the/path/dirc/file.xml", then DITA_ROOTPATH
# is "/the/path"
DITA_ROOTPATH=

# Directory containing JAPP scripts (like this one)
JAPP_ROOT=

# Temporary directory used to produce output files
JAPP_TMP=

# URL context. This is used to add some kind of context prefix
# in URLs. For instance, one may publish a page for jallib tutorial.
# Such context can be transformed in URL to "jallib/tutorials/the_tutorial".
# In this case: JAPP_CONTEXT_URL="jallib/tutorials"
# This is useful to prevent URL collision and segment content.
# Note: no "/" at the begining or the end, please
JAPP_CONTEXT_URL=


# Email configuration
#--------------------

# "From" address. Emails sent will use this address
# and put it in "From" header. This address must match
# someone with sufficient rights in Drupal website
FROM_ADDRESS="" 

# Password associated to 'from_address'. This couple of
# information allows to identify a user on Drupal's side.
# This password will be put as a mailhandler command in emails.
FROM_PASSWD=""

# "To" address. Emails will be sent to this address.
# This must corresponds to an address monitored by
# mailhandler
TO_ADDRESS=""

# "Sender" address. This must be set to an address known by
# account FROM_ADDRESS (eg. gmail), so email won't be detected
# as spam (this can occur if FROM_ADDRESS = TO_ADDRESS and 
# no Sender)
SENDER_ADDRESS=""

# SMTP host/port used to send email
SMTP_HOST="localhost"
SMTP_PORT=25



