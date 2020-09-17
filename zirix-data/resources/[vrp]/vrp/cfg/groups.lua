local cfg = {}

cfg.groups = {

	--[	Departamento de Justiça ]------------------------------------------------
	
	["juiz"] = {
		_config = {
			title = "Juiz(a)",
			gtype = "job"
		},
		"juiz.permissao",
	},
	["procurador"] = {
		_config = {
			title = "Procurador(a)",
			gtype = "job"
		},
		"procurador.permissao",
	},
	["promotor"] = {
		_config = {
			title = "Promotor(a)",
			gtype = "job"
		},
		"promotor.permissao",
	},
	["defensor"] = {
		_config = {
			title = "Defensor(a) Público",
			gtype = "job"
		},
		"defensor.permissao",
	},
	["advogado"] = {
		_config = {
			title = "Advogado(a)",
			gtype = "adv"
		},
		"advogado.permissao"
	},
	
	--[	Departamento de Policia ]------------------------------------------------
	
	["policia"] = {
		_config = {
			title = "POLICIA",
			gtype = "job"
		},
		"policia.permissao",
	},
	["paisana-policia"] = {
		_config = {
			title = "A PAISANA POLICIA",
			gtype = "job"
		},
		"paisana-policia.permissao",
	},

	["policia-ptr"] = {
		_config = {
			title = "EM PATRULHA",
			gtype = "ptr"
		},
		"policia-ptr.permissao",
	},

	["chefe-policia"] = {
		_config = {
			title = "Chefe de Polícia",
			gtype = "hie"
		},
		"chefe-policia.permissao"
	},
	["sub-chefe-policia"] = {
		_config = {
			title = "Sub Chefe de Polícia",
			gtype = "hie"
		},
		"sub-chefe-policia.permissao"
	},
	["inspetor"] = {
		_config = {
			title = "Inspetor de Polícia",
			gtype = "hie"
		},
		"inspetor.permissao"
	},
	["capitao"] = {
		_config = {
			title = "Capitão de Polícia",
			gtype = "hie"
		},
		"capitao.permissao"
	},
	["tenente"] = {
		_config = {
			title = "Tenente de Polícia",
			gtype = "hie"
		},
		"tenente.permissao"
	},
	["sub-tenente"] = {
		_config = {
			title = "Sub Tenente de Polícia",
			gtype = "hie"
		},
		"sub-tenente.permissao"
	},
	["primeiro-sargento"] = {
		_config = {
			title = "1º Sargento de Polícia",
			gtype = "hie"
		},
		"primeiro-sargento.permissao"
	},
	["segundo-sargento"] = {
		_config = {
			title = "2º Sargento de Polícia",
			gtype = "hie"
		},
		"segundo-sargento.permissao"
	},
	["agente-policia"] = {
		_config = {
			title = "Agente de Polícia",
			gtype = "hie"
		},
		"agente-policia.permissao"
	},
	["recruta-policia"] = {
		_config = {
			title = "Recruta de Polícia",
			gtype = "hie"
		},
		"recruta-policia.permissao"
	},
	
	--[	Departamento Médico ]----------------------------------------------------
	
	["ems"] = {
		_config = {
			title = "EMS",
			gtype = "job"
		},
		"ems.permissao",
	}, 
	["paisana-ems"] = {
		_config = {
			title = "EMS DE FOLGA",
			gtype = "job"
		},
		"paisana-ems.permissao"
	},
	
	["diretor-geral"] = {
		_config = {
			title = "Diretor Geral",
			gtype = "hie"
		},
		"diretor-geral.permissao"
	},
	["diretor-auxiliar"] = {
		_config = {
			title = "Diretor Auxiliar",
			gtype = "hie"
		},
		"diretor-auxiliar.permissao"
	},
	["medico-chefe"] = {
		_config = {
			title = "Médico Chefe",
			gtype = "hie"
		},
		"medico-chefe.permissao"
	},
	["medico-cirurgiao"] = {
		_config = {
			title = "Médico Cirurgião",
			gtype = "hie"
		},
		"medico-cirurgiao.permissao"
	},
	["medico-aulixiar"] = {
		_config = {
			title = "Médico Auxiliar",
			gtype = "hie"
		},
		"medico-aulixiar.permissao"
	},
	["medico"] = {
		_config = {
			title = "Médico",
			gtype = "hie"
		},
		"medico.permissao"
	},
	["paramedico"] = {
		_config = {
			title = "Paramédico",
			gtype = "hie"
		},
		"paramedico.permissao"
	},
	["enfermeiro"] = {
		_config = {
			title = "Enfermeiro",
			gtype = "hie"
		},
		"enfermeiro.permissao"
	},
	["socorrista"] = {
		_config = {
			title = "Socorrista",
			gtype = "hie"
		},
		"socorrista.permissao"
	},
	["estagiario"] = {
		_config = {
			title = "Estágiario",
			gtype = "hie"
		},
		"estagiario.permissao"
	},
	
	--[	Taxista ]----------------------------------------------------------------
	
	["taxista"] = {
		_config = {
			title = "Taxista",
			gtype = "job"
		},
		"taxista.permissao"
	},
	["paisana-taxista"] = {
		_config = {
			title = "Taxista de folga",
			gtype = "job"
		},
		"paisana-taxista.permissao"
	},
	
	--[	Mecânico ]---------------------------------------------------------------
	
	["mecanico"] = {
		_config = {
			title = "Mêcanico",
			gtype = "job"
		},
		"mecanico.permissao"
	},
	["paisana-mecanico"] = {
		_config = {
			title = "Mecânico de folga",
			gtype = "job"
		},
		"paisana-mecanico.permissao"
	},
	
	--[	Bennys ]-----------------------------------------------------------------

	["bennys"] = {
		_config = {
			title = "Membro da Bennys",
			gtype = "job"
		},
		"bennys.permissao"
	},
	["lider-bennys"] = {
		_config = {
			title = "Líder da Bennys",
			gtype = "hie"
		},
		"lider-bennys.permissao"
	},
	
	--[	Organização de produção e venda de drogas ][ Ballas ]--------------------
	
	["ballas"] = {
		_config = {
			title = "Membro dos Ballas",
			gtype = "job"
		},
		"ballas.permissao"
	},
	["lider-ballas"] = {
		_config = {
			title = "Líder dos Ballas",
			gtype = "hie"
		},
		"lider-ballas.permissao"
	},
	
	--[	Organização de produção e venda de drogas ][ Grove ]---------------------
	
	["grove"] = {
		_config = {
			title = "Membro da Grove",
			gtype = "job"
		},
		"grove.permissao"
	},
	["lider-grove"] = {
		_config = {
			title = "Líder da Grove",
			gtype = "hie"
		},
		"lider-grove.permissao"
	},
	
	--[	Organização de produção e venda de drogas ][ Families ]------------------
	
	["families"] = {
		_config = {
			title = "Membro da Families",
			gtype = "job"
		},
		"families.permissao"
	},
	["lider-families"] = {
		_config = {
			title = "Líder da Families",
			gtype = "hie"
		},
		"lider-families.permissao"
	},
	
	--[	Organização de produção e vendas de armas ][ Medellin ]------------------
	
	["medellin"] = {
		_config = {
			title = "Membro Medellín",
			gtype = "job"
		},
		"medellin.permissao"
	},
	["lider-medellin"] = {
		_config = {
			title = "Líder Medellín",
			gtype = "hie"
		},
		"lider-medellin.permissao"
	},
	
	--[	Organização de produção e vendas de armas ][ Motoclub ]------------------
	
	["motoclub"] = {
		_config = {
			title = "Membro Motoclub",
			gtype = "job"
		},
		"oc-guns02.permissao"
	},
	["lider-motoclub"] = {
		_config = {
			title = "Presidente Motoclub",
			gtype = "hie"
		},
		"lider-motoclub.permissao"
	},
	
	--[	Organização de lavagem de dinheiro ][ Bratva ]---------------------------
	
	["bratva"] = {
		_config = {
			title = "Membro Bratva",
			gtype = "job"
		},
		"bratva.permissao"
	},
	["lider-bratva"] = {
		_config = {
			title = "Chefão Bratva",
			gtype = "hie"
		},
		"lider-bratva.permissao"
	},

	--[	Organização de lavagem de dinheiro ][ Ndrangheta ]-----------------------
	
	["ndrangheta"] = {
		_config = {
			title = "Membro Ndrangheta",
			gtype = "job"
		},
		"ndrangheta.permissao"
	},
	["lider-ndrangheta"] = {
		_config = {
			title = "Líder Ndrangheta",
			gtype = "hie"
		},
		"lider-ndrangheta.permissao"
	},

	--[	Organização de Produção de coletes e acessórios ][ NynaX ]---------------
	
	["nynax"] = {
		_config = {
			title = "Membro NynaX",
			gtype = "job"
		},
		"nynax.permissao"
	},
	["lider-nynax"] = {
		_config = {
			title = "Líder NynaX",
			gtype = "hie"
		},
		"lider-nynax.permissao"
	},

	--[	Organização de Produção de coletes e acessórios ][ Semantic ]------------
	
	["semantic"] = {
		_config = {
			title = "Membro Semantic",
			gtype = "job"
		},
		"semantic.permissao"
	},
	["lider-semantic"] = {
		_config = {
			title = "Líder Semantic",
			gtype = "hie"
		},
		"lider-semantic.permissao"
	},

	--[	Staff ]------------------------------------------------------------------

	["manager"] = {
		_config = {
			title = "Manager",
			gtype = "staff"
		},
		"manager.permissao"
	},
	["off-manager"] = {
		_config = {
			title = "Manager",
			gtype = "staff"
		},
		"off-manager.permissao"
	},

	["administrador"] = {
		_config = {
			title = "Administrador(a)",
			gtype = "staff"
		},
		"administrador.permissao"
	},
	["off-administrador"] = {
		_config = {
			title = "Administrador(a)",
			gtype = "staff"
		},
		"off-administrador.permissao"
	},

	["moderador"] = {
		_config = {
			title = "Moderador(a)",
			gtype = "staff"
		},
		"moderador.permissao"
	},
	["off-moderador"] = {
		_config = {
			title = "Moderador(a)",
			gtype = "staff"
		},
		"off-moderador.permissao"
	},

	["suporte"] = {
		_config = {
			title = "Suporte",
			gtype = "staff"
		},
		"suporte.permissao"
	},
	["off-suporte"] = {
		_config = {
			title = "Suporte",
			gtype = "staff"
		},
		"off-suporte.permissao"
	},
	["aprovador-wl"] = {
		_config = {
			title = "Aprovador WL",
			gtype = "staff"
		},
		"aprovador-wl.permissao"
	},

	--[	Pass ]-------------------------------------------------------------------

	["ultimate"] = {
		_config = {
			title = "Ultimate Pass",
			gtype = "pass"
		},
		"ultimate.permissao"
	},
	["platinum"] = {
		_config = {
			title = "Platinum Pass",
			gtype = "pass"
		},
		"platinum.permissao"
	},
	["gold"] = {
		_config = {
			title = "Gold Pass",
			gtype = "pass"
		},
		"gold.permissao"
	},
	["standard"] = {
		_config = {
			title = "Standard Pass",
			gtype = "pass"
		},
		"standard.permissao"
	}
}

cfg.users = {
	[1] = { "manager" }
}

cfg.selectors = {}

return cfg