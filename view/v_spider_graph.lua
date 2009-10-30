require 'm_io_util'

local config = {
	    home = "/usr/local/itvision",
		www_dir = '/www'
}


local head = [[digraph Pointset {
	/*
	graph [center rankdir=LR bgcolor="#808080",size="100.0,100.0",page="10.0,10.0",ranksep=3,ratio=auto]
	 node [width=.4, height=.4, shape=plaintext];
	graph [center rankdir=LR bgcolor="#ffffff",ranksep=3,ratio=auto]
	*/
	edge [fontsize="13.0"];
	node [fontsize="11.0"];

	"center" [ label="",shape="point",style="filled",color="green",pos="0,0" ];
]]

local tail =  [[} ]]

	--"dimgrey", --cinza escuro
	--"lightskyblue", --azul claro
local rainbow = { 
	"gainsboro",
	"red",
	"orange",
	"yellow",
	"limegreen",
	"deepskyblue1",
	"darkorchid2",
	--"navy"
}

local metric_names = {
	"disponibilidade",
	"eficiencia",
	"escalabilidade",
	"custo",
	"capacidade",
	"nivel de servico",
	"seguranca",
	"integridade",
	"gerenciabilidade",
	"continuidade"
}

function coords (f)
	local t = {}
	local p, c, s
	local n = table.getn(f)

	p = 2*math.pi / n
	for i = 1,n do
		s = math.floor(math.sin(p*i)*1000)/1000
		c = math.floor(math.cos(p*i)*1000)/1000
		table.insert(t, {s,c})
	end

	return t
end


function mk_spider_graph(factor, filename)
	local a, b, i, i_c, f, v
	local multi=120
	local cds = coords (factor)
	local graphviz_file = head
	local node_config = ' [label="", shape="point",style="filled",color="white",pos="'
	local arrow_config = '",penwidth=3.0,arrowsize="1.0",labelfontsize=9,headlabel="'

	for i, v in ipairs(cds) do
	--	if factor[i] == -1 then 
	--		f = 0
	--	else
			f = factor[i]
	--	end
			
		a = ( v[1]*(1+0.2*f) )*multi
		b = ( v[2]*(1+0.2*f) )*multi
		i_c = rainbow[factor[i]+2]
	
		-- NAO CONSGUI COLOCAR UMA URL NO LABEL DESTE GRAFIO DE ARANHA!!!!
		-- O ARQUIVO .map FICA VAZIO.
		graphviz_file = graphviz_file .. '\t' ..i.. node_config ..a.. ', ' ..b
			.. '",url="report_efici.lp"];\n' .. '\t"center" -> "'
			..i..'" [ label=" ",color="'..i_c.. arrow_config ..metric_names[i]..' ('..f..')"'
			..',url="report_efici.lp" ];\n'
	end

	graphviz_file = graphviz_file .. tail
	--text_file_writer(config.path..'/spider.gv', graphviz_file)
	text_file_writer(filename..'.gv', graphviz_file)

	--os.execute('neato -n -Tpng -ospider.png spider.gv')
	--png_filename = string.gsub(filename, 'gv$', 'png')
	--map_filename = string.gsub(filename, 'gv$', 'map')
	os.execute('neato -Gcharset=latin1 -n -Tcmapx -o'..filename..'.map -Tpng -o'..filename..'.png '..filename..'.gv')


end

--[[ DEBUG
local factor = { 4,5,-1,-1,3,1,-1,2,-1,-1 }
mk_spider_graph(factor, config.home..config.www_dir..'/figs/spider.gv')
]]--





