import{r as v}from"./index-C1Ev6BtL.js";var u={exports:{}},t={};/**
 * @license React
 * react-jsx-runtime.production.min.js
 *
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */var _;function y(){if(_)return t;_=1;var R=v(),a=Symbol.for("react.element"),x=Symbol.for("react.fragment"),c=Object.prototype.hasOwnProperty,l=R.__SECRET_INTERNALS_DO_NOT_USE_OR_YOU_WILL_BE_FIRED.ReactCurrentOwner,d={key:!0,ref:!0,__self:!0,__source:!0};function s(n,e,f){var r,o={},i=null,p=null;f!==void 0&&(i=""+f),e.key!==void 0&&(i=""+e.key),e.ref!==void 0&&(p=e.ref);for(r in e)c.call(e,r)&&!d.hasOwnProperty(r)&&(o[r]=e[r]);if(n&&n.defaultProps)for(r in e=n.defaultProps,e)o[r]===void 0&&(o[r]=e[r]);return{$$typeof:a,type:n,key:i,ref:p,props:o,_owner:l.current}}return t.Fragment=x,t.jsx=s,t.jsxs=s,t}var m;function O(){return m||(m=1,u.exports=y()),u.exports}var E=O();const q={render:()=>E.jsx("frame",{Size:UDim2.fromOffset(200,200)}),title:"Button"};export{q as preview};
