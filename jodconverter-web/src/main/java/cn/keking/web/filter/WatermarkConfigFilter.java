package cn.keking.web.filter;

import cn.keking.config.WatermarkConfigConstants;

import javax.servlet.*;
import java.io.IOException;

/**
 * @author chenjh
 * @since 2020/5/13 18:34
 */
public class WatermarkConfigFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) {

    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        String watermarkTxt = request.getParameter("watermarkTxt");
        request.setAttribute("watermarkTxt", watermarkTxt != null ? watermarkTxt : WatermarkConfigConstants.getWatermarkTxt());
        request.setAttribute("watermarkXSpace", WatermarkConfigConstants.getWatermarkXSpace());
        request.setAttribute("watermarkYSpace", WatermarkConfigConstants.getWatermarkYSpace());
        request.setAttribute("watermarkFont", WatermarkConfigConstants.getWatermarkFont());
        request.setAttribute("watermarkFontsize", WatermarkConfigConstants.getWatermarkFontsize());
        request.setAttribute("watermarkColor", WatermarkConfigConstants.getWatermarkColor());
        request.setAttribute("watermarkAlpha", WatermarkConfigConstants.getWatermarkAlpha());
        request.setAttribute("watermarkWidth", WatermarkConfigConstants.getWatermarkWidth());
        request.setAttribute("watermarkHeight", WatermarkConfigConstants.getWatermarkHeight());
        request.setAttribute("watermarkAngle", WatermarkConfigConstants.getWatermarkAngle());
        filterChain.doFilter(request, response);
    }

    @Override
    public void destroy() {

    }
}
