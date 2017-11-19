using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using SbsSW.SwiPlCs;

public class GM : MonoBehaviour
{
    public GameObject GameOverText;
    public Text PointsText;
    public Text ConsoleText;

    [SerializeField]
    private bool _gameRunning;
    private Agent _agent;

    static private GM _instance;

    private void Awake()
    {
        if(_instance)
        {
            Destroy(gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    // Use this for initialization
    void Start ()
    {
        _gameRunning = true;

        Environment.SetEnvironmentVariable("SWI_HOME_DIR", @"C:\Program Files (x86)\swipl");
        Environment.SetEnvironmentVariable("Path", Environment.GetEnvironmentVariable("Path") + @";C:\Program Files (x86)\swipl;C:\Program Files (x86)\swipl\bin");
        if (!PlEngine.IsInitialized)
        {
            String[] param = { "-q"/*, "-f", Application.dataPath + "/Resources/wumpus.pl"*/ };
            PlEngine.Initialize(param);

            try
            {
                PlQuery.PlCall("consult('c:/Users/pedro/PrologProjects/The-Wumpus-World/wumpus.pl')");
                PlQuery.PlCall("start");
                Debug.Log("start");
            }
            catch (SbsSW.SwiPlCs.Exceptions.PlException ex)
            {
                Debug.Log("Exception handled: " + ex.Message);
            }
        }
    }

    private void Update()
    {
        PointsText.text = "Points: " + GetAgent().Points;
    }

    public void PrologQuery(string query)
    {
        PlQuery.PlCall(query);
        ConsoleText.text += query + "\n";
    }

    static public GM GetInstance()
    {
        return _instance;
    }

    public Agent GetAgent()
    {
        if(!_agent)
        {
            _agent = GameObject.FindGameObjectWithTag("Agent").GetComponent<Agent>();
        }
        return _agent;
    }

    public bool GetGameRunning()
    {
        return _gameRunning;
    }

    public void SetGameRunning(bool running)
    {
        _gameRunning = running;

        if(!running)
        {
            GameOverText.SetActive(true);
            GameOverText.GetComponent<Text>().text = "Game Over\nPoints: " + GetAgent().Points;
            StartCoroutine(GetInstance().Restart());
        }
    }

    IEnumerator Restart()
    {
        yield return new WaitForSeconds(3);
        PlEngine.PlCleanup();
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void UpdatePoints(int points)
    {
        PointsText.text = "Points: " + points;
    }

    public string GetCurrentAction()
    {
        string action = "";
        //PlQuery actionQuery = new PlQuery("agent_location([X,Y])");
        //actionQuery.NextSolution();

        Debug.Log("agent");
        PlQuery actionQuery = new PlQuery("agent_next_action(Action)");

        foreach (PlQueryVariables s in actionQuery.SolutionVariables)
        {
            action = s["Action"].ToString();
            Debug.Log(action);
        }

        //Debug.Log("Fim.");
        actionQuery.Dispose();

        return action;
    }

    public void ReadyNextAction()
    {
        Debug.Log("ready");
        PlQuery actionQuery = new PlQuery("ready_next_action");
        actionQuery.NextSolution();
        actionQuery.Dispose();
    }

    public void ExecuteCurrentAction()
    {
        PlQuery actionQuery = new PlQuery("execute_current_action");
        actionQuery.NextSolution();
        actionQuery.Dispose();
    }
}
