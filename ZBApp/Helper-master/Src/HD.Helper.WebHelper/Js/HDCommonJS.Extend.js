
/**
 * JSFrame Name:EasyJs
 * File Name:JSFrame
 * Date:2014-11-28 上午10:50:09
 * Copyright (c) 2014, China Link Communications LTD All Rights Reserved.
 * Author:by sicd
 * Describe:
 *         Commonly used function of js code
 *
 */

/**
 1、原生JavaScript实现字符串长度截取
 2、原生JavaScript获取域名主机
 3、原生JavaScript清除空格
 4、原生JavaScript替换全部
 5、原生JavaScript转义html标签
 6、原生JavaScript还原html标签
 7、原生JavaScript时间日期格式转换
 8、原生JavaScript判断是否为数字类型
 9、原生JavaScript设置cookie值
 10、原生JavaScript获取cookie值
 11、原生JavaScript加入收藏夹
 12、原生JavaScript设为首页
 13、原生JavaScript判断IE6
 14、原生JavaScript加载样式文件
 15、原生JavaScript返回脚本内容
 16、原生JavaScript清除脚本内容
 17、原生JavaScript动态加载脚本文件
 18、原生JavaScript返回按ID检索的元素对象
 19、原生JavaScript返回浏览器版本内容
 20、原生JavaScript元素显示的通用方法
 21、原生JavaScript中有insertBefore方法,可惜却没有insertAfter方法?用如下函数实现
 22、原生JavaScript中兼容浏览器绑定元素事件
 23、原生JavaScript光标停在文字的后面，文本框获得焦点时调用
 24、原生JavaScript检验URL链接是否有效
 25、原生JavaScript格式化CSS样式代码
 26、原生JavaScript压缩CSS样式代码
 27、原生JavaScript获取当前路径
 28、原生JavaScriptIP转成整型
 29、原生JavaScript整型解析为IP地址
 30、原生JavaScript实现checkbox全选与全不选
 31、原生JavaScript判断是否移动设备
 32、原生JavaScript判断是否移动设备访问
 33、原生JavaScript判断是否苹果移动设备访问
 34、原生JavaScript判断是否安卓移动设备访问
 35、原生JavaScript判断是否Touch屏幕
 36、原生JavaScript判断是否在安卓上的谷歌浏览器
 37、原生JavaScript判断是否打开视窗
 38、原生JavaScript获取移动设备初始化大小
 39、原生JavaScript获取移动设备最大化大小
 40、原生JavaScript获取移动设备屏幕宽度
 41、原生JavaScript完美判断是否为网址
 42、原生JavaScript根据样式名称检索元素对象
 43、原生JavaScript判断是否以某个字符串开头
 44、原生JavaScript判断是否以某个字符串结束
 45、原生JavaScript返回IE浏览器的版本号
 46、原生JavaScript获取页面高度
 47、原生JavaScript获取页面scrollLeft
 48、原生JavaScript获取页面可视宽度
 49、原生JavaScript获取页面宽度
 **/

/**
 * 字符串长度截取 params: str:字符串 length:长度
 */
function cutstr(str, length) {
    var temp;
    var icount = 0;
    var patrn = /[^\x00-\xff]/;
    var strre = "";
    for (var i = 0; i < str.length; i++) {
        if (icount < len - 1) {
            temp = str.substr(i, 1);
            if (patrn.exec(temp) == null) {
                icount = icount + 1;
            } else {
                icount = icount + 2;
            }
            strre += temp;
        } else {
            break;
        }
    }
    return strre + "...";
}

/**
 * 获取域名主机 params: url:域名
 */
function getHost(url) {
    var host = "null";
    if (typeof url == "undefined" || null == url) {
        url = window.location.href;
    }
    var regex = /^\w+\:\/\/([^\/]*).*/;
    var match = url.match(regex);
    if (typeof match != "undefined" && null != match) {
        host = match[1];
    }
    return host;
}

/**
 * 清除空格 为String 对象添加方法 trim（） 以此兼容不支持此方法的浏览器
 */
if (!String.prototype.trim) {
    String.prototype.trim = function () {
        var reExtraSpace = /^\s*(.*?)\s+$/;
        return this.replace(reExtraSpace, "$1");
    };
}

/**
 * 替换全部,多种方式的替换规则 为String 对象添加方法 replaceAll 兼容浏览器
 * 
 * 第三参数 修饰符 描述 i 执行对大小写不敏感的匹配。 g 执行全局匹配（查找所有匹配而非在找到第一个匹配后停止）。 m 执行多行匹配。
 */
if (!String.prototype.replaceAll) {
    String.prototype.replaceAll = function (s1, s2, type) {
        return this.replace(new RegExp(s1, type), s2);
    };
}

/**
 * 转义html标签
 */
function htmlEncode(text) {
    return text.replace(/&/g, '&').replace(/\"/g, '"').replace(/</g,
        '<').replace(/>/g, '>');
}

/**
 * 还原html标签
 */
function htmlDecode(text) {
    return text.replace(/&/g, '&').replace(/"/g, '\"').replace(
        /</g, '<').replace(/>/g, '>');
}

/**
 * 时间日期格式转换 (按需更改，是否调用原方法， 还是重写)
 */
if (!Date.prototye.format && !Date.prototype.Format) {
    Date.prototype.Format = function (formatStr) {
        var str = formatStr;
        var Week = ['日', '一', '二', '三', '四', '五', '六'];
        str = str.replace(/yyyy|YYYY/, this.getFullYear());
        str = str.replace(/yy|YY/,
            (this.getYear() % 100) > 9 ? (this.getYear() % 100).toString()
                : '0' + (this.getYear() % 100));
        str = str.replace(/MM/,
            (this.getMonth() + 1) > 9 ? (this.getMonth() + 1).toString()
                : '0' + (this.getMonth() + 1));
        str = str.replace(/M/g, (this.getMonth() + 1));
        str = str.replace(/w|W/g, Week[this.getDay()]);
        str = str.replace(/dd|DD/, this.getDate() > 9 ? this.getDate()
            .toString() : '0' + this.getDate());
        str = str.replace(/d|D/g, this.getDate());
        str = str.replace(/hh|HH/, this.getHours() > 9 ? this.getHours()
            .toString() : '0' + this.getHours());
        str = str.replace(/h|H/g, this.getHours());
        str = str.replace(/mm/, this.getMinutes() > 9 ? this.getMinutes()
            .toString() : '0' + this.getMinutes());
        str = str.replace(/m/g, this.getMinutes());
        str = str.replace(/ss|SS/, this.getSeconds() > 9 ? this.getSeconds()
            .toString() : '0' + this.getSeconds());
        str = str.replace(/s|S/g, this.getSeconds());
        return str;
    };
}

/**
 * 判断是否为数字类型
 */
function isDigit(value) {
    var patrn = /^[0-9]*$/;
    if (patrn.exec(value) == null || value == "") {
        return false;
    } else {
        return true;
    }
}

/**
 * 设置cookie值 escape(str) 对值进行编码 unescape(str)进行解码 (ECMAScript v3 反对使用该方法，应用使用
 * decodeURI() 和 decodeURIComponent() 替代它。)
 * 
 * param:
 * 
 * name:名称
 * 
 * value:名称对应值
 * 
 * path:为了控制cookie可以访问的目录 例： path=/shop";就表示当前cookie仅能在shop目录下使用（url地址）。
 * 
 * expires:过期时间 F * domain : 指定可访问cookie的主机名 域名
 */
function setCookie(name, value, Hours) {
    var d = new Date();
    var offset = 8;
    var utc = d.getTime() + (d.getTimezoneOffset() * 60000);
    var nd = utc + (3600000 * offset);
    var exp = new Date(nd);
    exp.setTime(exp.getTime() + Hours * 60 * 60 * 1000);
    document.cookie = name + "=" + escape(value) + ";path=/;expires="
        + exp.toGMTString() + ";domain=sicd.com;";
}

/**
 * 获取cookie值 unescape()不推荐使用 用 decodeURI()
 * 
 */
function getCookie(name) {
    var arr = document.cookie
        .match(new RegExp("(^| )" + name + "=([^;]*)(;|$)"));
    if (arr != null)
        return unescape(arr[2]);
    return null;
}

/**
 * 加入收藏夹
 */
function AddFavorite(sURL, sTitle) {
    try {
        window.external.addFavorite(sURL, sTitle);
    } catch (e) {
        try {
            window.sidebar.addPanel(sTitle, sURL, "");
        } catch (e) {
            alert("加入收藏失败，请使用Ctrl+D进行添加");
        }
    }
}

/**
 * 设为首页
 */

function setHomepage() {
    if (document.all) {
        document.body.style.behavior = 'url(#default#homepage)';
        document.body.setHomePage('http://***');
    } else if (window.sidebar) {
        if (window.netscape) {
            try {
                netscape.security.PrivilegeManager
                    .enablePrivilege("UniversalXPConnect");
            } catch (e) {
                alert("该操作被浏览器拒绝，如果想启用该功能，请在地址栏内输入 about:config,然后将项 signed.applets.codebase_principal_support 值该为true");
            }
        }
        var prefs = Components.classes['@mozilla.org/preferences-service;1']
            .getService(Components.interfaces.nsIPrefBranch);
        prefs.setCharPref('browser.startup.homepage', 'http://***');
    }
}

/**
 * 判断IE6 设置背景图片缓存解决闪烁问题 （ie6默认背景图片不缓存）
 * 
 * document.execCommand() 用法 想了解的童鞋请访问:
 * http://www.cnblogs.com/sicd/p/4134641.html 记得点个赞哟 ^_^
 */
var ua = navigator.userAgent.toLowerCase();
var isIE6 = ua.indexOf("msie 6") > -1;
if (isIE6) {
    try {
        document.execCommand("BackgroundImageCache", false, true);
    } catch (e) {
    }
}

/**
 * 动态加载 CSS 样式文件
 */
function LoadStyle(url) {
    try {
        document.createStyleSheet(url);
    } catch (e) {
        var cssLink = document.createElement('link');
        cssLink.rel = 'stylesheet';
        cssLink.type = 'text/css';
        cssLink.href = url;
        var head = document.getElementsByTagName('head')[0];
        head.appendChild(cssLink);
    }
}

/**
 * 返回脚本内容
 */
function evalscript(s) {
    if (s.indexOf('<script') == -1)
        return s;
    var p = /<script[^\>]*?>([^\x00]*?)<\/script>/ig;
    var arr = [];
    while (arr = p.exec(s)) {
        var p1 = /<script[^\>]*?src=\"([^\>]*?)\"[^\>]*?(reload=\"1\")?(?:charset=\"([\w\-]+?)\")?><\/script>/i;
        var arr1 = [];
        arr1 = p1.exec(arr[0]);
        if (arr1) {
            appendscript(arr1[1], '', arr1[2], arr1[3]);
        } else {
            p1 = /<script(.*?)>([^\x00]+?)<\/script>/i;
            arr1 = p1.exec(arr[0]);
            appendscript('', arr1[2], arr1[1].indexOf('reload=') != -1);
        }
    }
    return s;
}

/**
 * 清除脚本内容
 */
function stripscript(s) {
    return s.replace(/<script.*?>.*?<\/script>/ig, '');
}

/**
 * 动态加载脚本文件
 */
function appendscript(src, text, reload, charset) {
    var id = hash(src + text);
    if (!reload && in_array(id, evalscripts))
        return;
    if (reload && $(id)) {
        $(id).parentNode.removeChild($(id));
    }

    evalscripts.push(id);
    var scriptNode = document.createElement("script");
    scriptNode.type = "text/javascript";
    scriptNode.id = id;
    scriptNode.charset = charset ? charset
        : (BROWSER.firefox ? document.characterSet : document.charset);
    try {
        if (src) {
            scriptNode.src = src;
            scriptNode.onloadDone = false;
            scriptNode.onload = function () {
                scriptNode.onloadDone = true;
                JSLOADED[src] = 1;
            };
            scriptNode.onreadystatechange = function () {
                if ((scriptNode.readyState == 'loaded' || scriptNode.readyState == 'complete')
                    && !scriptNode.onloadDone) {
                    scriptNode.onloadDone = true;
                    JSLOADED[src] = 1;
                }
            };
        } else if (text) {
            scriptNode.text = text;
        }
        document.getElementsByTagName('head')[0].appendChild(scriptNode);
    } catch (e) {
    }
}

/**
 * 返回按ID检索的元素对象
 */
try {
    if (typeof (eval('$')) == "function") {
    } else {
        function $(id) {
            return !id ? null : document.getElementById(id);
        }
    }
} catch (e) {
    function $(id) {
        return !id ? null : document.getElementById(id);
    }
}

/**
 * 返回浏览器版本
 * 
 * 返回一个对象,对象属性：type，version
 */

function getExplorerInfo() {
    var explorer = window.navigator.userAgent.toLowerCase();
    // ie
    if (explorer.indexOf("msie") >= 0) {
        var ver = explorer.match(/msie ([\d.]+)/)[1];
        return {
            type: "IE",
            version: ver
        };
    }
    // firefox
    else if (explorer.indexOf("firefox") >= 0) {
        var ver = explorer.match(/firefox\/([\d.]+)/)[1];
        return {
            type: "Firefox",
            version: ver
        };
    }
    // Chrome
    else if (explorer.indexOf("chrome") >= 0) {
        var ver = explorer.match(/chrome\/([\d.]+)/)[1];
        return {
            type: "Chrome",
            version: ver
        };
    }
    // Opera
    else if (explorer.indexOf("opera") >= 0) {
        var ver = explorer.match(/opera.([\d.]+)/)[1];
        return {
            type: "Opera",
            version: ver
        };
    }
    // Safari
    else if (explorer.indexOf("Safari") >= 0) {
        var ver = explorer.match(/version\/([\d.]+)/)[1];
        return {
            type: "Safari",
            version: ver
        };
    }
}

/**
 * 显示元素 待验证 visibility hideen 会隐藏元素，但是会占用作用域
 */
// function $(id) {
// return !id ? null : document.getElementById(id);
// }
function display(id) {
    var obj = $(id);
    if (obj.style.visibility) {
        obj.style.visibility = obj.style.visibility == 'visible' ? 'hidden'
            : 'visible';
    } else {
        obj.style.display = obj.style.display == '' ? 'none' : '';
    }
}

/**
 * 与insertBefore方法（已存在）对应的insertAfter方法
 * 
 * 
 */
function insertAfter(newChild, refChild) {
    var parElem = refChild.parentNode;
    if (parElem.lastChild == refChild) {
        refChild.appendChild(newChild);
    } else {
        parElem.insertBefore(newChild, refChild.nextSibling);
    }
}

/**
 * 兼容浏览器绑定元素事件
 * 
 * obj：元素
 * 
 * evt:时间名称
 * 
 * fn:触发函数
 * 
 */

function addEventSamp(obj, evt, fn) {
    if (obj.addEventListener) {
        obj.addEventListener(evt, fn, false);
    } else if (obj.attachEvent) {
        obj.attachEvent('on' + evt, fn);
    }
}

/**
 * 光标停在文字的后面，文本框获得焦点时调用
 */
function focusLast() {
    var e = event.srcElement;
    var r = e.createTextRange();
    r.moveStart('character', e.value.length);
    r.collapse(true);
    r.select();
}

/**
 * 检验URL链接是否有效
 * 
 * .Open("GET",URL, false) true:异步；false:同步
 */
function getUrlState(URL) {
    var suc = false;
    var xmlhttp = new ActiveXObject("microsoft.xmlhttp");
    xmlhttp.Open("GET", URL, false);
    try {
        xmlhttp.Send();
    } catch (e) {
    } finally {
        var result = xmlhttp.responseText;
        if (result) {
            if (xmlhttp.Status == 200) {
                suc = true;
            } else {
                suc = false;
            }
        } else {
            suc = false;
        }
    }
    return suc;
}

/**
 * 格式化CSS样式代码
 */
function formatCss(s) {// 格式化代码
    s = s.replace(/\s*([\{\}\:\;\,])\s*/g, "$1");
    s = s.replace(/;\s*;/g, ";"); // 清除连续分号
    s = s.replace(/\,[\s\.\#\d]*{/g, "{");
    s = s.replace(/([^\s])\{([^\s])/g, "$1 {\n\t$2");
    s = s.replace(/([^\s])\}([^\n]*)/g, "$1\n}\n$2");
    s = s.replace(/([^\s]);([^\s\}])/g, "$1;\n\t$2");
    return s;
}

/**
 * 压缩CSS样式代码
 */
function yasuoCss(s) {// 压缩代码
    s = s.replace(/\/\*(.|\n)*?\*\//g, ""); // 删除注释
    s = s.replace(/\s*([\{\}\:\;\,])\s*/g, "$1");
    s = s.replace(/\,[\s\.\#\d]*\{/g, "{"); // 容错处理
    s = s.replace(/;\s*;/g, ";"); // 清除连续分号
    s = s.match(/^\s*(\S+(\s+\S+)*)\s*$/); // 去掉首尾空白
    return (s == null) ? "" : s[1];
}

/**
 * 获取当前路径
 */
function getCurrentPageUrl() {
    var currentPageUrl = "";
    if (typeof this.href === "undefined") {
        currentPageUrl = document.location.toString().toLowerCase();
    } else {
        currentPageUrl = this.href.toString().toLowerCase();
    }
    return currentPageUrl;
}

/**
 * ip 转 整型
 */
function _ip2int(ip) {
    var num = 0;
    ip = ip.split(".");
    num = Number(ip[0]) * 256 * 256 * 256 + Number(ip[1]) * 256 * 256
        + Number(ip[2]) * 256 + Number(ip[3]);
    num = num >>> 0;
    return num;
}

/**
 * 整型解析为IP地址
 */
function _int2iP(num) {
    var str;
    var tt = new Array();
    tt[0] = (num >>> 24) >>> 0;
    tt[1] = ((num << 8) >>> 24) >>> 0;
    tt[2] = (num << 16) >>> 24;
    tt[3] = (num << 24) >>> 24;
    str = String(tt[0]) + "." + String(tt[1]) + "." + String(tt[2]) + "."
        + String(tt[3]);
    return str;
}

/**
 * 实现checkbox全选与全不选
 */
function checkAll(selectAllBoxId, childBoxsId) {
    var selectall = document.getElementById(selectAllBoxId);
    var allbox = document.getElementsByName(childBoxsId);
    if (selectall.checked) {
        for (var i = 0; i < allbox.length; i++) {
            allbox[i].checked = true;
        }
    } else {
        for (var i = 0; i < allbox.length; i++) {
            allbox[i].checked = false;
        }
    }
}

/**
 * 判断是否移动设备
 */
function isMobile() {
    if (typeof this._isMobile === 'boolean') {
        return this._isMobile;
    }
    var screenWidth = this.getScreenWidth();
    var fixViewPortsExperiment = rendererModel.runningExperiments.FixViewport
        || rendererModel.runningExperiments.fixviewport;
    var fixViewPortsExperimentRunning = fixViewPortsExperiment
        && (fixViewPortsExperiment.toLowerCase() === "new");
    if (!fixViewPortsExperiment) {
        if (!this.isAppleMobileDevice()) {
            screenWidth = screenWidth / window.devicePixelRatio;
        }
    }
    var isMobileScreenSize = screenWidth < 600;
    var isMobileUserAgent = false;
    this._isMobile = isMobileScreenSize && this.isTouchScreen();
    return this._isMobile;
}

/**
 * 判断是否移动设备访问
 */
function isMobileUserAgent() {
    return (/iphone|ipod|android.*mobile|windows.*phone|blackberry.*mobile/i
        .test(window.navigator.userAgent.toLowerCase()));
}

/**
 * 判断是否苹果移动设备访问
 */
function isAppleMobileDevice() {
    return (/iphone|ipod|ipad|Macintosh/i.test(navigator.userAgent
        .toLowerCase()));
}

/**
 * 判断是否安卓移动设备访问
 */
function isAndroidMobileDevice() {
    return (/android/i.test(navigator.userAgent.toLowerCase()));
}

/**
 * 判断是否Touch屏幕
 */
function isTouchScreen() {
    return (('ontouchstart' in window) || window.DocumentTouch
        && document instanceof DocumentTouch);
}

/**
 * 判断是否在安卓上的谷歌浏览器
 */
function isNewChromeOnAndroid() {
    if (this.isAndroidMobileDevice()) {
        var userAgent = navigator.userAgent.toLowerCase();
        if ((/chrome/i.test(userAgent))) {
            var parts = userAgent.split('chrome/');

            var fullVersionString = parts[1].split(" ")[0];
            var versionString = fullVersionString.split('.')[0];
            var version = parseInt(versionString);

            if (version >= 27) {
                return true;
            }
        }
    }
    return false;
}

/**
 * 判断是否打开视窗
 */
function isViewportOpen() {
    return !!document.getElementById('wixMobileViewport');
}

/**
 * 获取移动设备初始化大小
 */
function getInitZoom() {
    if (!this._initZoom) {
        var screenWidth = Math.min(screen.height, screen.width);
        if (this.isAndroidMobileDevice() && !this.isNewChromeOnAndroid()) {
            screenWidth = screenWidth / window.devicePixelRatio;
        }
        this._initZoom = screenWidth / document.body.offsetWidth;
    }
    return this._initZoom;
}

/**
 * 获取移动设备最大化大小
 */
function getZoom() {
    var screenWidth = (Math.abs(window.orientation) === 90) ? Math.max(screen.height, screen.width) : Math.min(screen.height, screen.width);
    if (this.isAndroidMobileDevice() && !this.isNewChromeOnAndroid()) {
        screenWidth = screenWidth / window.devicePixelRatio;
    }
    var FixViewPortsExperiment = rendererModel.runningExperiments.FixViewport || rendererModel.runningExperiments.fixviewport;
    var FixViewPortsExperimentRunning = FixViewPortsExperiment && (FixViewPortsExperiment === "New" || FixViewPortsExperiment === "new");
    if (FixViewPortsExperimentRunning) {
        return screenWidth / window.innerWidth;
    } else {
        return screenWidth / document.body.offsetWidth;
    }
}
/**
 * 获取移动设备屏幕宽度
 */
function getScreenWidth() {
    var smallerSide = Math.min(screen.width, screen.height);
    var fixViewPortsExperiment = rendererModel.runningExperiments.FixViewport || rendererModel.runningExperiments.fixviewport;
    var fixViewPortsExperimentRunning = fixViewPortsExperiment && (fixViewPortsExperiment.toLowerCase() === "new");
    if (fixViewPortsExperiment) {
        if (this.isAndroidMobileDevice() && !this.isNewChromeOnAndroid()) {
            smallerSide = smallerSide / window.devicePixelRatio;
        }
    }
    return smallerSide;
}

/**
 * 完美判断是否为网址
 */
function IsURL(strUrl) {
    var regular = /^\b(((https?|ftp):\/\/)?[-a-z0-9]+(\.[-a-z0-9]+)*\.(?:com|edu|gov|int|mil|net|org|biz|info|name|museum|asia|coop|aero|[a-z][a-z]|((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]\d)|\d))\b(\/[-a-z0-9_:\@&?=+,.!\/~%\$]*)?)$/i;
    if (regular.test(strUrl)) {
        return true;
    }
    else {
        return false;
    }
}

/**
 * 根据样式名称检索元素对象
 */
function getElementsByClassName(name) {
    var tags = document.getElementsByTagName('*') || document.all;
    var els = [];
    for (var i = 0; i < tags.length; i++) {
        if (tags[i].className) {
            var cs = tags[i].className.split(' ');
            for (var j = 0; j < cs.length; j++) {
                if (name == cs[j]) {
                    els.push(tags[i]);
                    break;
                }
            }
        }
    }
    return els;
}

/**
 * 判断是否以某个字符串开头
 */
if (!String.prototype.startWith) {
    String.prototype.startWith = function (s) {
        return this.indexOf(s) == 0;
    };
}

/**
 * 判断是否以某个字符串结束
 */
if (!String.prototype.endWith) {
    String.prototype.endWith = function (s) {
        var d = this.length - s.length;
        return (d >= 0 && this.lastIndexOf(s) == d);
    };
}

/**
 * 返回IE浏览器的版本号
 */
function getIE() {
    if (window.ActiveXObject) {
        var v = navigator.userAgent.match(/MSIE ([^;]+)/)[1];
        return parseFloat(v.substring(0, v.indexOf(".")));
    }
    return false;
}

/**
 * 获取页面高度
 */
function getPageHeight() {
    var g = document, a = g.body, f = g.documentElement, d = g.compatMode == "BackCompat"
        ? a
        : g.documentElement;
    return Math.max(f.scrollHeight, a.scrollHeight, d.clientHeight);
}

/**
 * 获取页面scrollLeft
 */
function getPageScrollLeft() {
    var a = document;
    return a.documentElement.scrollLeft || a.body.scrollLeft;
}


/**
 * 获取页面宽度
 */
function getPageWidth() {
    var g = document, a = g.body, f = g.documentElement, d = g.compatMode == "BackCompat"
        ? a
        : g.documentElement;
    return Math.max(f.scrollWidth, a.scrollWidth, d.clientWidth);
}

/**
 * 获取页面scrollTop
 */
function getPageScrollTop() {
    var a = document;
    return a.documentElement.scrollTop || a.body.scrollTop;
}

/**
 * 获取页面可视高度
 */
function getPageViewHeight() {
    var d = document, a = d.compatMode == "BackCompat"
        ? d.body
        : d.documentElement;
    return a.clientHeight;
}







/*****************************补充  ********************************************/
//删除cookies 
function delCookie(name) {
    var exp = new Date();
    exp.setTime(exp.getTime() - 1);
    var cval = getCookie(name);
    if (cval != null)
        document.cookie = name + "=" + cval + ";expires=" + exp.toGMTString();
}