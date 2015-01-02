suite("player-finish-event",function(){setup(function(){this.element=document.createElement("div"),document.documentElement.appendChild(this.element),this.player=this.element.animate([],1e3)}),teardown(function(){this.element.parent&&this.element.removeChild(this.target)}),test("fire when player completes",function(e){var t=!1,i=!1,n=this.player;n.onfinish=function(s){assert(t,"must not be called synchronously"),assert.equal(this,n),assert.equal(s.target,n),assert.equal(s.currentTime,1e3),assert.equal(s.timelineTime,1100),i&&assert(!1,"must not get fired twice"),i=!0,e()},tick(100),tick(1100),tick(2100),t=!0}),test("fire when reversed player completes",function(e){this.player.onfinish=function(t){assert.equal(t.currentTime,0),assert.equal(t.timelineTime,1001),e()},tick(0),tick(500),this.player.reverse(),tick(501),tick(1001)}),test("fire after player is cancelled",function(e){this.player.onfinish=function(t){assert.equal(t.currentTime,0),assert.equal(t.timelineTime,1,"event must be fired on next sample"),e()},tick(0),this.player.cancel(),tick(1)}),test("multiple event listeners",function(e){function t(e){return function(){i++,assert.equal(i,e)}}var i=0,n=t(0);this.player.addEventListener("finish",t(1)),this.player.addEventListener("finish",t(2)),this.player.addEventListener("finish",n),this.player.addEventListener("finish",t(3)),this.player.removeEventListener("finish",n),this.player.onfinish=function(){assert.equal(i,3),e()},tick(0),this.player.cancel(),tick(1e3)})});