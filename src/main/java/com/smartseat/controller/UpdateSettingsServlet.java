package com.smartseat.controller;

import com.smartseat.dao.SettingsDAO;
import com.smartseat.util.AppConfigListener;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Enumeration;

@WebServlet("/UpdateSettingsServlet")
public class UpdateSettingsServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        SettingsDAO dao = new SettingsDAO();
        boolean allUpdated = true;

        // Form ke saare parameters loop mein update karein
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String key = parameterNames.nextElement();
            String value = request.getParameter(key);
            
            if (!dao.updateSetting(key, value)) {
                allUpdated = false;
            }
        }

        
        
        if (allUpdated) {
            // Cache refresh karein
            AppConfigListener.refreshSettings(getServletContext());
            response.sendRedirect("admin/settings.jsp?message=Settings Updated and Cache Refreshed!");
        }
    }
}