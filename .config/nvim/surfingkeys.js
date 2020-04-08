aceVimMap('kj', '<Esc>', 'insert');
aceVimMap('kj', '<Esc>', 'visual');
aceVimMap('v', '<Esc>', 'visual');
aceVimMap(';', ':', 'normal');
aceVimMap('H', '^', 'normal');
aceVimMap('L', '$', 'normal');
aceVimMap('H', '^', 'visual');
aceVimMap('L', '$', 'visual');
// 因为是递归映射的，所有
// aceVimMap('(', '()<Esc>i','insert');
aceVimMap('q', ':wq', 'normal');
map('gxl', 'gx$');
map('>', '>>');
map('<', '<<');
Hints.characters='abcdefghilmnopqrstuvwxyzkj';
settings.caretViewport=[100, 70, window.innerHeight-170, window.innerWidth / 3];
settings.focusAfterClosed='right';
// moveToFirstNonWhiteSpaceCharacter
mapkey('<Ctrl-y>', '#7Copy page title and url as markdown', function() {
    Clipboard.write('['+document.title+']'+'('+window.location.href+')' );
});
