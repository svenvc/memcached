"
Means some sort of server error prevents the server from carrying out the command. In cases of severe server errors, which make it impossible to continue serving the client (this shouldn't normally happen), the server will close the connection after sending the error line. This is the only case in which the server closes a connection to a client.
"
Class {
	#name : #MDServerError,
	#superclass : #MDError,
	#category : #'Memcached-Exceptions'
}
