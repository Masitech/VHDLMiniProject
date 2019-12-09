#define SI_SIGNAL D5
#define PH_0 D6
#define PH_90 D7

int PH_0_C = 0;
int PH_90_C = 0;

int PH_0_P = 0;
int PH_90_P = 0;

volatile unsigned long PH_0_T_P = 0;
volatile unsigned long PH_90_T_P = 0;
volatile unsigned long PH_0_T = 0;
volatile unsigned long PH_90_T = 0;


//decting reset
volatile unsigned long PH_0_T_F = 0;
volatile unsigned long PH_90_T_F = 0;

bool IntrPH0 = false; // display if only interrupt has happened
bool IntrPH90 = false;
signed int Tdifference = 4; //in ms

unsigned long previousMillis = 0;

float phaseSI_Out = 0;
int frequencyPWM = 1000;
int PH_0_Freq = 0;
int PH_90_Freq = 0;
float periodSI = 0;

void  ICACHE_RAM_ATTR ISR_PH_0() {
  noInterrupts(); // disable interrupt
  PH_0_T_P = PH_0_T;  //timing for different rising edges
  if (!IntrPH0 && !IntrPH90) { // SYNC
    PH_0_T = micros();
    IntrPH0 = true;
  }
  interrupts(); //enable interrupt
}
void ICACHE_RAM_ATTR ISR_PH_90() {
  noInterrupts(); // disable interrupt
  PH_90_T_P = PH_90_T;
  if (!IntrPH90 && IntrPH0) { //SYNC
    PH_90_T = micros();
    IntrPH90 = true;
  }
  interrupts(); //enable interrupt
}
void setup()
{
  pinMode(SI_SIGNAL, OUTPUT);
  pinMode(PH_0, INPUT);
  pinMode(PH_90, INPUT);
  analogWriteFreq(frequencyPWM);
  analogWrite(SI_SIGNAL, 512);  // 1000hz freq
  attachInterrupt(digitalPinToInterrupt(PH_0), ISR_PH_0, RISING);
  attachInterrupt(digitalPinToInterrupt(PH_90), ISR_PH_90, RISING);
  Serial.begin(115200);
}

void loop()
{
  unsigned long currentMillis = millis();
  abs((PH_0_T_F - PH_90_T_F));
  noInterrupts(); // disable interrupt

  if ((currentMillis - previousMillis >= 1000) && IntrPH0 && IntrPH90) {
    previousMillis = currentMillis;
    Tdifference =  PH_90_T - PH_0_T;
    periodSI = (float)(1000000 / frequencyPWM);
    float phase = 360 * (Tdifference / periodSI);
    IntrPH0 = false;
    IntrPH90 = false;
    Serial.print("Phase ");
    Serial.println(phase);
  }
  interrupts(); //enable interrupt
}
