#! /usr/bin/env python3 

#Moduli ( solo il necessario ;) )
from sys import exit
from sys import argv
from smtplib import SMTPAuthenticationError
from smtplib import SMTP_SSL
from traceback import format_exc
from smtplib import SMTPServerDisconnected
from smtplib import SMTPConnectError
from ssl import SSLError

#Variabili
arg_counter = len(argv)
smtp_server = ""
get_arg_email = ""
get_arg_passwd = ""
get_arg_serveraddr = ""
get_arg_dest = ""
get_mail_text = ""
get_arg_port = ""

#Verifica degli argomenti (len(argv)), si lo so avrei anche potuto aprire un try-except IndexError
if arg_counter == 6:
        get_arg_email = argv[1]
        get_arg_passwd = argv[2]
        get_arg_serveraddr = argv[3]
        get_arg_dest = argv[5]
        get_arg_port = argv[4]
        port_to_use = int(get_arg_port)
else: 
    print ("Usage: [mailsender.py] <email> <passwd> <serveraddr> <port_to_use> <destination>")
    exit(1)

#Qui si scrive il corpo del messaggio
try:
    get_mail_text = input("Email body: ")
    while get_mail_text == "" or get_mail_text == " ":
        get_mail_text = input("Email body: ")
except KeyboardInterrupt:
    print("\n\033[33mUser exited (^C)\033[0m\n")
    exit(127)

#Funzione che invia l'email
def sendMyEmail(srv, srvport, serveraddr, my_email, my_passwd, recv, message):
    print ("\033[34m*\033[0m Server Address:\033[32m %s\033[0m " %serveraddr)
    print ("\033[34m*\033[0m Email:\033[32m %s \033[0m " %my_email)
    print ("\033[34m*\033[0m To:\033[32m %s \033[0m" %recv)
    print ("\033[34m*\033[0m Text:\033[32m %s \033[0m"%message)
    srv = SMTP_SSL(serveraddr, srvport)
    srv.login(my_email, my_passwd)
    srv.sendmail(my_email,recv,message)
    print ("\033[33m*\033[0m Trying to send mail...")
    srv.quit()
    print ("\033[33m*\033[0m Ending the connection with the server...\n")

#Blocco try-except (con piu' eccezioni)
#per sendMyEmail(...)
try:
    sendMyEmail(smtp_server, port_to_use, get_arg_serveraddr, get_arg_email, get_arg_passwd, get_arg_dest, get_mail_text)
except SMTPAuthenticationError:
    get_traceback = format_exc()
    print ("\033[33mLogin error! Maybe you typed wrong login values\033[0m\n\033[31mBelow the traceback\033[0m\n\n\033[33m")
    print (get_traceback)
    print ("\033[0m")
    exit(2)
except SMTPServerDisconnected:
    get_traceback = format_exc()
    print("\033[33mServer suddenly disconnected! I don't know reason...\033[0m\n\033[31mBelow the traceback\033[0m\n\n\033[33m")
    print(get_traceback)
    print("\033[0m")
    exit(3)
except SMTPConnectError:
    get_traceback = format_exc()
    print("\033[33mCan't connect to server! I don't know reason....\033[0m\n\033[31mBelow the traceback\033[0m\n\n\033[33m")
    print(get_traceback)
    print("\033[0m")
    exit(4)
except SSLError:
    print("\033[33mProblem with SSL Encryption! I don't know reason...\033[0m\n\033[31mBelow the traceback\033[0m\n\n\033[33m")
    print(get_traceback)
    print("\033[0m")
    exit(5)
except KeyboardInterrupt:
    print("\n\033[33mUser exited (^C)\033[0m\n")
    exit(127)

#Se tutto e' andato bene
print("\033[32mSeems that all went good...\n\033[0m\033[33mExiting...\033[0m\n")
exit(0)


