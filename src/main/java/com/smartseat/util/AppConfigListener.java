package com.smartseat.util;

import com.smartseat.dao.SettingsDAO;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.Map;

@WebListener
public class AppConfigListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Application start hote hi settings load karein
        refreshSettings(sce.getServletContext());
        System.out.println("Smart-Seat: System Settings Loaded into Application Scope.");
    }

    public static void refreshSettings(javax.servlet.ServletContext context) {
        SettingsDAO dao = new SettingsDAO();
        Map<String, String> settings = dao.getAllSettings();
        
        // Saari settings ko application scope mein set kar dein
        for (Map.Entry<String, String> entry : settings.entrySet()) {
            context.setAttribute(entry.getKey(), entry.getValue());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup logic agar zaroorat ho
    }
}