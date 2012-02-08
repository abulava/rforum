// ----------------------------------------------------------------------------
// markItUp!
// ----------------------------------------------------------------------------
// Copyright (C) 2008 Jay Salvat
// http://markitup.jaysalvat.com/
// ----------------------------------------------------------------------------
// BBCode tags example
// http://en.wikipedia.org/wiki/Bbcode
// ----------------------------------------------------------------------------
// Feel free to add more tags
// ----------------------------------------------------------------------------
mySettings = {
	previewParserPath:	'', // path to your BBCode parser
	markupSet: [
		{name:'Bold', key:'B', openBlockWith:'[b]', closeBlockWith:'[/b]'},
		{name:'Italic', key:'I', openBlockWith:'[i]', closeBlockWith:'[/i]'},
		{name:'Underline', key:'U', openBlockWith:'[u]', closeBlockWith:'[/u]'},
		{name:'Stroke', key:'S', openBlockWith:'[s]', closeBlockWith:'[/s]'},
		{separator:'---------------' },
		{name:'Picture', key:'P', replaceWith:'[img][![Url]!][/img]'},
		{name:'Link', key:'L', openBlockWith:'[url=[![Url]!]]', closeBlockWith:'[/url]', placeHolder:'Your text to link here...'},
		{separator:'---------------' },
		{	name:'Colors', 
			className:'colors', 
			openBlockWith:'[color=[![Color]!]]', 
			closeBlockWith:'[/color]', 
				dropMenu: [
					{name:'Yellow',	openBlockWith:'[color=yellow]', 	closeBlockWith:'[/color]', className:"col1-1" },
					{name:'Orange',	openBlockWith:'[color=orange]', 	closeBlockWith:'[/color]', className:"col1-2" },
					{name:'Red', 	openBlockWith:'[color=red]', 	closeBlockWith:'[/color]', className:"col1-3" },
					
					{name:'Blue', 	openBlockWith:'[color=blue]', 	closeBlockWith:'[/color]', className:"col2-1" },
					{name:'Purple', openBlockWith:'[color=purple]', 	closeBlockWith:'[/color]', className:"col2-2" },
					{name:'Green', 	openBlockWith:'[color=green]', 	closeBlockWith:'[/color]', className:"col2-3" },
					
					{name:'White', 	openBlockWith:'[color=white]', 	closeBlockWith:'[/color]', className:"col3-1" },
					{name:'Gray', 	openBlockWith:'[color=gray]', 	closeBlockWith:'[/color]', className:"col3-2" },
					{name:'Black',	openBlockWith:'[color=black]', 	closeBlockWith:'[/color]', className:"col3-3" }
				]
		},
		{name:'Quotes', openBlockWith:'[quote]', closeBlockWith:'[/quote]', className:"markItUpButton11" },
                {separator:'---------------' },
		{name:'Clean', className:"clean", replaceWith:function(markitup) { return markitup.selection.replace(/\[(.*?)\]/g, "") } },
	]
}
