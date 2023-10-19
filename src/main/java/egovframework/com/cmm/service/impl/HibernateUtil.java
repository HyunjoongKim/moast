package egovframework.com.cmm.service.impl;

/*
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.boot.registry.StandardServiceRegistry;
*/

public class HibernateUtil {
	/**
	 * 
	 * 현재 안쓰일 예정.............
	 * 
	 */
	/*
	private static SessionFactory sessionFactory;
    private static String configFile = "hibernate/hibernate.cfg.xml";
 
    static {
        try {
            Configuration cfg = new Configuration().configure(configFile);
            StandardServiceRegistryBuilder sb = new StandardServiceRegistryBuilder();
            sb.applySettings(cfg.getProperties());
            StandardServiceRegistry standardServiceRegistry = sb.build();
            sessionFactory = cfg.buildSessionFactory(standardServiceRegistry);
        } catch (Throwable th) {
            System.err.println("Enitial SessionFactory creation failed" + th);
            throw new ExceptionInInitializerError(th);
        }
    }
 
    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
 
    public void shutdown() {
        sessionFactory.close();
    }
    
    */
}
