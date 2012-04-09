
function dg_echo(int sockfd, SA *pcliaddr, socklen_t clilen)
	int n;
	sockelen_t len;
	char mesg[MAXLINE];

	for (;;) do
		len = clilen;
		n = Recvfrom(sockfd, mesg, MAXLINE, 0, pcliaddr, &len)
		Sendto(sockfd, mesg, n, 0, pcliaddr, len);
	end
end

function main(argv)
	int sockfd;
	struct sockaddr_in servaddr, cliaddr;

	sockfd = Socket(AF_INET, SOCK_STREAM, 0);

	bzero(&servaddr, sizeof(servaddr))
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	servaddr.sin_port = htons(SERV_PORT);

	Bind(sockfd, (SA*)&servaddr, sizeof(servaddr));

	dg_echo(sockfd, (SA*)&cliaddr, sizeof(cliaddr));
end


main(arg)
