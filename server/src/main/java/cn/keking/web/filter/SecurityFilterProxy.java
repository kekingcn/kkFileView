package cn.keking.web.filter;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@Configuration
public class SecurityFilterProxy extends OncePerRequestFilter {


    private String NOT_ALLOW_METHODS = "TRACE";

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        if((","+NOT_ALLOW_METHODS+",").indexOf(","+request.getMethod().toUpperCase()+",") > -1) {
            response.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            response.setHeader("Content-Type", "text/html; charset=iso-8859-1");
            response.getWriter().println("Method Not Allowed");
            return;
        }
        super.doFilter(request, response, filterChain);
    }
}
