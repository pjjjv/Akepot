!function(t,i){function e(t){return t._timing.delay+t.activeDuration+t._timing.endDelay}function n(i){this._frames=t.normalizeKeyframes(i)}function r(){for(var t=!1;u.length;)u.shift()._updateChildren(),t=!0;return t}n.prototype={getFrames:function(){return this._frames}},i.Animation=function(i,e,r){return this.target=i,this._timingInput=r,this._timing=t.normalizeTimingInput(r),this.timing=t.makeTiming(r),this.effect="function"==typeof e?e:new n(e),this._effect=e,this.activeDuration=t.calculateActiveDuration(this._timing),this};var a=Element.prototype.animate;Element.prototype.animate=function(t,e){return i.timeline.play(new i.Animation(this,t,e))};var o=document.createElement("div");i.newUnderlyingPlayerForAnimation=function(t){var i=t.target||o,e=t._effect;return"function"==typeof e&&(e=[]),a.apply(i,[e,t._timingInput])},i.bindPlayerForAnimation=function(t){t.source&&"function"==typeof t.source.effect&&i.bindPlayerForCustomEffect(t)};var u=[];i.awaitStartTime=function(t){null===t.startTime&&t._isGroup&&(0==u.length&&requestAnimationFrame(r),u.push(t))};var s=window.getComputedStyle;Object.defineProperty(window,"getComputedStyle",{configurable:!0,enumerable:!0,value:function(){var t=s.apply(this,arguments);return r()&&(t=s.apply(this,arguments)),t}}),i.Player.prototype._updateChildren=function(){if(null!==this.startTime&&this.source&&this._isGroup)for(var t=this.source._timing.delay,i=0;i<this.source.children.length;i++){var n,r=this.source.children[i];i>=this._childPlayers.length?(n=window.document.timeline.play(r),r.player=this.source.player,this._childPlayers.push(n)):n=this._childPlayers[i],n.startTime!=this.startTime+t&&(n.startTime=this.startTime+t,n._updateChildren()),-1==this.playbackRate&&this.currentTime<t&&-1!==n.currentTime&&(n.currentTime=-1),this.source instanceof window.AnimationSequence&&(t+=e(r))}},window.Animation=i.Animation,window.Element.prototype.getAnimationPlayers=function(){return document.timeline.getAnimationPlayers().filter(function(t){return null!==t.source&&t.source.target==this}.bind(this))},i.groupChildDuration=e}(webAnimationsShared,webAnimationsMaxifill,webAnimationsTesting);