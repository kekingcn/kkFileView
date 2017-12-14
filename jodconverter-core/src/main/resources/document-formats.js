[
  {
    "name": "Portable Document Format",
    "extension": "pdf",
    "mediaType": "application/pdf",
    "storePropertiesByFamily": {
      "DRAWING": {"FilterName": "draw_pdf_Export"},
      "SPREADSHEET": {"FilterName": "calc_pdf_Export"},
      "PRESENTATION": {"FilterName": "impress_pdf_Export"},
      "TEXT": {"FilterName": "writer_pdf_Export"}
    }
  },
  {
    "name": "Macromedia Flash",
    "extension": "swf",
    "mediaType": "application/x-shockwave-flash",
    "storePropertiesByFamily": {
      "DRAWING": {"FilterName": "draw_flash_Export"},
      "PRESENTATION": {"FilterName": "impress_flash_Export"}
    }
  },
  {
    "name": "HTML",
    "extension": "html",
    "mediaType": "text/html",
    "inputFamily": "TEXT",
    "storePropertiesByFamily": {
      "SPREADSHEET": {"FilterName": "HTML (StarCalc)"},
      "PRESENTATION": {"FilterName": "impress_html_Export"},
      "TEXT": {"FilterName": "HTML (StarWriter)"}
    }
  },
  {
    "name": "OpenDocument Text",
    "extension": "odt",
    "mediaType": "application/vnd.oasis.opendocument.text",
    "inputFamily": "TEXT",
    "storePropertiesByFamily": {"TEXT": {"FilterName": "writer8"}}
  },
  {
    "name": "OpenOffice.org 1.0 Text Document",
    "extension": "sxw",
    "mediaType": "application/vnd.sun.xml.writer",
    "inputFamily": "TEXT",
    "storePropertiesByFamily": {"TEXT": {"FilterName": "StarOffice XML (Writer)"}}
  },
  {
    "name": "Microsoft Word",
    "extension": "doc",
    "mediaType": "application/msword",
    "inputFamily": "TEXT",
    "storePropertiesByFamily": {"TEXT": {"FilterName": "MS Word 97"}}
  },
  {
    "name": "Microsoft Word 2007 XML",
    "extension": "docx",
    "mediaType": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    "inputFamily": "TEXT"
  },
  {
    "name": "Rich Text Format",
    "extension": "rtf",
    "mediaType": "text/rtf",
    "inputFamily": "TEXT",
    "storePropertiesByFamily": {"TEXT": {"FilterName": "Rich Text Format"}}
  },
  {
    "name": "WordPerfect",
    "extension": "wpd",
    "mediaType": "application/wordperfect",
    "inputFamily": "TEXT"
  },
  {
    "name": "Plain Text",
    "extension": "txt",
    "mediaType": "text/plain",
    "inputFamily": "TEXT",
    "loadProperties": {
      "FilterName": "Text (encoded)",
      "FilterOptions": "utf8"
    },
    "storePropertiesByFamily": {"TEXT": {
      "FilterName": "Text (encoded)",
      "FilterOptions": "utf8"
    }}
  },
  {
    "name": "MediaWiki wikitext",
    "extension": "wiki",
    "mediaType": "text/x-wiki",
    "storePropertiesByFamily": {"TEXT": {"FilterName": "MediaWiki"}}
  },
  {
    "name": "OpenDocument Spreadsheet",
    "extension": "ods",
    "mediaType": "application/vnd.oasis.opendocument.spreadsheet",
    "inputFamily": "SPREADSHEET",
    "storePropertiesByFamily": {"SPREADSHEET": {"FilterName": "calc8"}}
  },
  {
    "name": "OpenOffice.org 1.0 Spreadsheet",
    "extension": "sxc",
    "mediaType": "application/vnd.sun.xml.calc",
    "inputFamily": "SPREADSHEET",
    "storePropertiesByFamily": {"SPREADSHEET": {"FilterName": "StarOffice XML (Calc)"}}
  },
  {
    "name": "Microsoft Excel",
    "extension": "xls",
    "mediaType": "application/vnd.ms-excel",
    "inputFamily": "SPREADSHEET",
    "storePropertiesByFamily": {"SPREADSHEET": {"FilterName": "MS Excel 97"}}
  },
  {
    "name": "Microsoft Excel 2007 XML",
    "extension": "xlsx",
    "mediaType": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    "inputFamily": "SPREADSHEET"
  },
  {
    "name": "Comma Separated Values",
    "extension": "csv",
    "mediaType": "text/csv",
    "inputFamily": "SPREADSHEET",
    "loadProperties": {
      "FilterName": "Text - txt - csv (StarCalc)",
      "FilterOptions": "44,34,0"
    },
    "storePropertiesByFamily": {"SPREADSHEET": {
      "FilterName": "Text - txt - csv (StarCalc)",
      "FilterOptions": "44,34,0"
    }}
  },
  {
    "name": "Tab Separated Values",
    "extension": "tsv",
    "mediaType": "text/tab-separated-values",
    "inputFamily": "SPREADSHEET",
    "loadProperties": {
      "FilterName": "Text - txt - csv (StarCalc)",
      "FilterOptions": "9,34,0"
    },
    "storePropertiesByFamily": {"SPREADSHEET": {
      "FilterName": "Text - txt - csv (StarCalc)",
      "FilterOptions": "9,34,0"
    }}
  },
  {
    "name": "OpenDocument Presentation",
    "extension": "odp",
    "mediaType": "application/vnd.oasis.opendocument.presentation",
    "inputFamily": "PRESENTATION",
    "storePropertiesByFamily": {"PRESENTATION": {"FilterName": "impress8"}}
  },
  {
    "name": "OpenOffice.org 1.0 Presentation",
    "extension": "sxi",
    "mediaType": "application/vnd.sun.xml.impress",
    "inputFamily": "PRESENTATION",
    "storePropertiesByFamily": {"PRESENTATION": {"FilterName": "StarOffice XML (Impress)"}}
  },
  {
    "name": "Microsoft PowerPoint",
    "extension": "ppt",
    "mediaType": "application/vnd.ms-powerpoint",
    "inputFamily": "PRESENTATION",
    "storePropertiesByFamily": {"PRESENTATION": {"FilterName": "MS PowerPoint 97"}}
  },
  {
    "name": "Microsoft PowerPoint 2007 XML",
    "extension": "pptx",
    "mediaType": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "inputFamily": "PRESENTATION"
  },
  {
    "name": "OpenDocument Drawing",
    "extension": "odg",
    "mediaType": "application/vnd.oasis.opendocument.graphics",
    "inputFamily": "DRAWING",
    "storePropertiesByFamily": {"DRAWING": {"FilterName": "draw8"}}
  },
  {
    "name": "Scalable Vector Graphics",
    "extension": "svg",
    "mediaType": "image/svg+xml",
    "storePropertiesByFamily": {"DRAWING": {"FilterName": "draw_svg_Export"}}
  }
]
