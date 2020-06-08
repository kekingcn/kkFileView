package cn.keking.web.filter;

import org.owasp.esapi.ESAPI;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Pattern;

public class XSSFilter implements Filter {

    private void initScriptPatterns() {
        scriptPatterns = new LinkedList<>();
        // Avoid anything between script tags
        Pattern scriptPattern = Pattern.compile("<script>(.*?)</script>", Pattern.CASE_INSENSITIVE);
        scriptPatterns.add(scriptPattern);
        // Avoid anything in a src='...' type of expression
        scriptPattern = Pattern.compile("src[\r\n]*=[\r\n]*\\\'(.*?)\\\'", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
        scriptPattern = Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
        // Remove any lonesome </script> tag
        scriptPattern = Pattern.compile("</script>", Pattern.CASE_INSENSITIVE);

        scriptPatterns.add(scriptPattern);
        // Remove any lonesome <script ...> tag
        scriptPattern = Pattern.compile("<script(.*?)>", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
        // Avoid eval(...) expressions
        scriptPattern = Pattern.compile("eval\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
        // Avoid expression(...) expressions
        scriptPattern = Pattern.compile("expression\\((.*?)\\)", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
        // Avoid javascript:... expressions
        scriptPattern = Pattern.compile("javascript:", Pattern.CASE_INSENSITIVE);

        scriptPatterns.add(scriptPattern);
        // Avoid vbscript:... expressions
        scriptPattern = Pattern.compile("vbscript:", Pattern.CASE_INSENSITIVE);

        scriptPatterns.add(scriptPattern);
        // Avoid onload= expressions
        scriptPattern = Pattern.compile("onload(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
        // Avoid onerror= expressions
        scriptPattern = Pattern.compile("onerror(.*?)=", Pattern.CASE_INSENSITIVE | Pattern.MULTILINE | Pattern.DOTALL);

        scriptPatterns.add(scriptPattern);
    }

    private static List<Pattern> scriptPatterns;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        initScriptPatterns();
    }

    @Override
    public void destroy() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        boolean paramCheck = request.getParameterMap().values().stream().flatMap(x -> Arrays.stream(x)).anyMatch(value -> checkXSS(value));
        if (paramCheck) {
            ((HttpServletResponse) response).sendError(HttpServletResponse.SC_FORBIDDEN);
        } else {
            chain.doFilter(request, response);
        }
    }


    private boolean checkXSS(String value) {
        if (value != null) {
            // NOTE: It's highly recommended to use the ESAPI library and uncomment the following line to
            // avoid encoded attacks.
            value = ESAPI.encoder().canonicalize(value);

            // Avoid null characters
            value = value.replaceAll("", "");
            for (Pattern pattern : scriptPatterns) {
                if (pattern.matcher(value).find()) {
                    return true;
                }
            }
        }
        return false;
    }

}