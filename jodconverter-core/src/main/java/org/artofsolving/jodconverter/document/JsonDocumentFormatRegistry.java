//
// JODConverter - Java OpenDocument Converter
// Copyright 2004-2012 Mirko Nasato and contributors
//
// JODConverter is Open Source software, you can redistribute it and/or
// modify it under either (at your option) of the following licenses
//
// 1. The GNU Lesser General Public License v3 (or later)
//    -> http://www.gnu.org/licenses/lgpl-3.0.txt
// 2. The Apache License, Version 2.0
//    -> http://www.apache.org/licenses/LICENSE-2.0.txt
//
package org.artofsolving.jodconverter.document;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonDocumentFormatRegistry extends SimpleDocumentFormatRegistry {

    public JsonDocumentFormatRegistry(InputStream input) throws JSONException, IOException {
        readJsonArray(IOUtils.toString(input));
    }

    public JsonDocumentFormatRegistry(String source) throws JSONException {
        readJsonArray(source);
    }

    private void readJsonArray(String source) throws JSONException {
        JSONArray array = new JSONArray(source);
        for (int i = 0; i < array.length(); i++) {
            JSONObject jsonFormat = array.getJSONObject(i);
            DocumentFormat format = new DocumentFormat();
            format.setName(jsonFormat.getString("name"));
            format.setExtension(jsonFormat.getString("extension"));
            format.setMediaType(jsonFormat.getString("mediaType"));
            if (jsonFormat.has("inputFamily")) {
                format.setInputFamily(DocumentFamily.valueOf(jsonFormat.getString("inputFamily")));
            }
            if (jsonFormat.has("loadProperties")) {
                format.setLoadProperties(toJavaMap(jsonFormat.getJSONObject("loadProperties")));
            }
            if (jsonFormat.has("storePropertiesByFamily")) {
                JSONObject jsonStorePropertiesByFamily = jsonFormat.getJSONObject("storePropertiesByFamily");
                for (String key : JSONObject.getNames(jsonStorePropertiesByFamily)) {
                    Map<String,?> storeProperties = toJavaMap(jsonStorePropertiesByFamily.getJSONObject(key));
                    format.setStoreProperties(DocumentFamily.valueOf(key), storeProperties);
                }
            }
            addFormat(format);
        }
    }

    private Map<String,?> toJavaMap(JSONObject jsonMap) throws JSONException {
        Map<String,Object> map = new HashMap<String,Object>();
        for (String key : JSONObject.getNames(jsonMap)) {
            Object value = jsonMap.get(key);
            if (value instanceof JSONObject) {
                map.put(key, toJavaMap((JSONObject) value));
            } else {
                map.put(key, value);
            }
        }
        return map;
    }

}
