SELECT
	 server.web_hostname 
	,server.host
	,server.was_hostname 
	,server.service
	,server.port
	,deploy.build_no
	,server.host || ':' || server.port cmd
FROM
(
	SELECT
		 web.hostname web_hostname
		,was.host
		,was.hostname was_hostname
		,port.service
		,port.port
		--,was.node_cnt
	FROM
		 host_info web
		,host_info was
		,port_info port
	where web.host_id = was.parent_id
	and was.service = port.service
	and was.node_cnt = port.node_cnt
	and web.type ='web'
	and web.use_yn ='Y'
	and was.type = 'was'
	and was.use_yn ='Y'
	and port.use_yn = 'Y'
) server,
(
	select 
		 build_no
		,web_hostname
		,min(was_hostname) was_hostname
		,min(services) services
		
	from
	(
		SELECT
			 build_no
			,web_hostname
			,was_hostname
			,group_concat(service) services
		from deploy_mgt
		WHERE health_check_yn = 'N'
		and deploy_tp = 'N'
		group by build_no, web_hostname,was_hostname
	)
	group by build_no, web_hostname
) deploy
WHERE server.web_hostname = deploy.web_hostname
and server.was_hostname = deploy.was_hostname
and deploy.services like '%' || server.service || '%'
order by server.web_hostname, server.was_hostname, server.port
