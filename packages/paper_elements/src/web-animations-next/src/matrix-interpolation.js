!function(r){function n(r,n,a){return Math.max(Math.min(r,a),n)}function a(a,t,o){var i=r.dot(a,t);i=n(i,-1,1);var f=[];if(1===i)f=a;else for(var u=Math.acos(i),v=1*Math.sin(o*u)/Math.sqrt(1-i*i),c=0;4>c;c++)f.push(a[c]*(Math.cos(o*u)-i*v)+t[c]*v);return f}var t=function(){function r(r,n){for(var a=[[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]],t=0;4>t;t++)for(var o=0;4>o;o++)for(var i=0;4>i;i++)a[t][o]+=n[t][i]*r[i][o];return a}function n(r){return 0==r[0][2]&&0==r[0][3]&&0==r[1][2]&&0==r[1][3]&&0==r[2][0]&&0==r[2][1]&&1==r[2][2]&&0==r[2][3]&&0==r[3][2]&&1==r[3][3]}function a(a,t,o,i,f){for(var u=[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]],v=0;4>v;v++)u[v][3]=f[v];for(var v=0;3>v;v++)for(var c=0;3>c;c++)u[3][v]+=a[c]*u[c][v];var e=i[0],s=i[1],M=i[2],h=i[3],m=[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]];m[0][0]=1-2*(s*s+M*M),m[0][1]=2*(e*s-M*h),m[0][2]=2*(e*M+s*h),m[1][0]=2*(e*s+M*h),m[1][1]=1-2*(e*e+M*M),m[1][2]=2*(s*M-e*h),m[2][0]=2*(e*M-s*h),m[2][1]=2*(s*M+e*h),m[2][2]=1-2*(e*e+s*s),u=r(u,m);var l=[[1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1]];o[2]&&(l[2][1]=o[2],u=r(u,l)),o[1]&&(l[2][1]=0,l[2][0]=o[0],u=r(u,l)),o[0]&&(l[2][0]=0,l[1][0]=o[0],u=r(u,l));for(var v=0;3>v;v++)for(var c=0;3>c;c++)u[v][c]*=t[v];return n(u)?[u[0][0],u[0][1],u[1][0],u[1][1],u[3][0],u[3][1]]:u[0].concat(u[1],u[2],u[3])}return a}();r.composeMatrix=t,r.quat=a}(webAnimationsMinifill,webAnimationsTesting);