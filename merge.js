const fs = require('fs');

const original = require('/opt/semantic/.releaserc.json')
const existent = require('/opt/app/.releaserc.json');

const releaserc = merge(original, existent);

fs.writeFileSync("/opt/app/.releaserc.json", JSON.stringify(releaserc));

function merge(or, ex){
  const result = {...or, ...ex};

  if (ex.plugins != undefined){
    result.plugins = mergePlugins(or.plugins, ex.plugins)
  }

  return result;
}

function mergePlugins(or, ex){
  const plugins = or;

  for(let i in ex){
    const key = ex[i][0];

    const index = or.findIndex(e => e[0] === key)
    
    if (index === -1){
      plugins.push(...ex[i])
    }else{
      plugins[index] = ex[i] 
    }
  }

  return plugins
}