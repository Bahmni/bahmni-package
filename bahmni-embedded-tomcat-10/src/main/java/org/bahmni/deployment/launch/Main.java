package org.bahmni.deployment.launch;

import org.apache.catalina.LifecycleException;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.Context;

import java.io.File;
import java.net.MalformedURLException;

import static java.lang.System.getenv;

public class Main {
    public static void main(String[] args) throws LifecycleException {
        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(getenv("SERVER_PORT")));
        tomcat.setBaseDir(getenv("BASE_DIR"));

        Context context = tomcat.addWebapp(getenv("CONTEXT_PATH"), new File(getenv("WAR_DIRECTORY")).getAbsolutePath());
        context.setSessionTimeout(120);
        context.setUseHttpOnly(false);

        tomcat.start();
        tomcat.getServer().await();
    }
}
