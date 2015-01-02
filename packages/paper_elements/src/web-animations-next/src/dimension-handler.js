!function(scope,testing){function parseDimension(unitRegExp,string){if(string=string.trim().toLowerCase(),"0"==string&&"px".search(unitRegExp)>=0)return{px:0};if(/^[^(]*$|^calc/.test(string)){string=string.replace(/calc\(/g,"(");var matchedUnits={};string=string.replace(unitRegExp,function(e){return matchedUnits[e]=null,"U"+e});for(var taggedUnitRegExp="U("+unitRegExp.source+")",typeCheck=string.replace(/[-+]?(\d*\.)?\d+/g,"N").replace(new RegExp("N"+taggedUnitRegExp,"g"),"D").replace(/\s[+-]\s/g,"O").replace(/\s/g,""),reductions=[/N\*(D)/g,/(N|D)[*/]N/g,/(N|D)O\1/g,/\((N|D)\)/g],i=0;i<reductions.length;)reductions[i].test(typeCheck)?(typeCheck=typeCheck.replace(reductions[i],"$1"),i=0):i++;if("D"==typeCheck){for(var unit in matchedUnits){var result=eval(string.replace(new RegExp("U"+unit,"g"),"").replace(new RegExp(taggedUnitRegExp,"g"),"*0"));if(!isFinite(result))return;matchedUnits[unit]=result}return matchedUnits}}}function mergeDimensionsNonNegative(e,i){return mergeDimensions(e,i,!0)}function mergeDimensions(e,i,n){var t,r=[];for(t in e)r.push(t);for(t in i)r.indexOf(t)<0&&r.push(t);return e=r.map(function(i){return e[i]||0}),i=r.map(function(e){return i[e]||0}),[e,i,function(e){var i=e.map(function(i,t){return 1==e.length&&n&&(i=Math.max(i,0)),scope.numberToString(i)+r[t]}).join(" + ");return e.length>1?"calc("+i+")":i}]}var lengthUnits="px|em|ex|ch|rem|vw|vh|vmin|vmax|cm|mm|in|pt|pc",parseLength=parseDimension.bind(null,new RegExp(lengthUnits,"g")),parseLengthOrPercent=parseDimension.bind(null,new RegExp(lengthUnits+"|%","g")),parseAngle=parseDimension.bind(null,/deg|rad|grad|turn/g);scope.parseLength=parseLength,scope.parseLengthOrPercent=parseLengthOrPercent,scope.consumeLengthOrPercent=scope.consumeParenthesised.bind(null,parseLengthOrPercent),scope.parseAngle=parseAngle,scope.mergeDimensions=mergeDimensions;var consumeLength=scope.consumeParenthesised.bind(null,parseLength),consumeSizePair=scope.consumeRepeated.bind(void 0,consumeLength,/^/),consumeSizePairList=scope.consumeRepeated.bind(void 0,consumeSizePair,/^,/);scope.consumeSizePairList=consumeSizePairList;var parseSizePairList=function(e){var i=consumeSizePairList(e);return i&&""==i[1]?i[0]:void 0},mergeNonNegativeSizePair=scope.mergeNestedRepeated.bind(void 0,mergeDimensionsNonNegative," "),mergeNonNegativeSizePairList=scope.mergeNestedRepeated.bind(void 0,mergeNonNegativeSizePair,",");scope.mergeNonNegativeSizePair=mergeNonNegativeSizePair,scope.addPropertiesHandler(parseSizePairList,mergeNonNegativeSizePairList,["background-size"]),scope.addPropertiesHandler(parseLengthOrPercent,mergeDimensionsNonNegative,["border-bottom-width","border-image-width","border-left-width","border-right-width","border-top-width","flex-basis","font-size","height","line-height","max-height","max-width","outline-width","width"]),scope.addPropertiesHandler(parseLengthOrPercent,mergeDimensions,["border-bottom-left-radius","border-bottom-right-radius","border-top-left-radius","border-top-right-radius","bottom","left","letter-spacing","margin-bottom","margin-left","margin-right","margin-top","min-height","min-width","outline-offset","padding-bottom","padding-left","padding-right","padding-top","perspective","right","shape-margin","text-indent","top","vertical-align","word-spacing"])}(webAnimationsMinifill,webAnimationsTesting);