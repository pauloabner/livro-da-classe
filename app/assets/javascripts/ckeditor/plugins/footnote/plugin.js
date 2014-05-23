CKEDITOR.plugins.add( 'footnote', {
  icons: 'footnote',
  init: function( editor ) {
    editor.addCommand( 'footnoteDialog', new CKEDITOR.dialogCommand( 'footnoteDialog' ) );
    editor.ui.addButton( 'Footnote', {
        label: 'Insere uma nota de rodapé',
        command: 'footnoteDialog',
        toolbar: 'insert'
    });

    CKEDITOR.dialog.add( 'footnoteDialog', this.path + 'dialogs/footnote.js' );

    // add the plugin css
    if (typeof CKEDITOR.config.contentsCss === 'string') {
      CKEDITOR.config.contentsCss = [CKEDITOR.config.contentsCss];
    } 

    CKEDITOR.config.contentsCss.push(CKEDITOR.basePath + CKEDITOR.plugins.basePath + 'footnote/plugin.css');

    // walk around for the image path
    CKEDITOR.addCss('a.footnote {background-image: url(' + CKEDITOR.getUrl(this.path + 'icons/footnote_red.png') + ');}')

  }
});
