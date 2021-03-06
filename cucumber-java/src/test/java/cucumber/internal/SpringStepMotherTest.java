package cucumber.internal;

import cucumber.steps.SpringSteps;
import org.junit.Before;

public class SpringStepMotherTest extends StepMotherTest {
    @Before
    public void createStepMother() {
        mother = new SpringStepMother();
        ((SpringStepMother) mother).setConfigs(new String[]{"steps.xml"});
        mother.registerClass(SpringSteps.class);
    }
}
