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
            String[] param = { "-q", "-f", Application.dataPath + "/Resources/wumpus.pl" };
            PlEngine.Initialize(param);

            //PrologQuery("assert(start)");
            PlQuery c = new PlQuery("start");
            try
            {
                c.NextSolution();
                Debug.Log("OK");
            }
            catch (SbsSW.SwiPlCs.Exceptions.PlException e)
            {
                Debug.Log(e.ToString());
            }
            c.Dispose();
            GetNextAction();
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

    public string GetNextAction()
    {
        PlQuery actionQuery = new PlQuery("agent_location([X,Y])");
        //actionQuery.NextSolution();
        Debug.Log("Ini:");
        foreach (PlQueryVariables s in actionQuery.SolutionVariables)
            Debug.Log(s["X"].ToString());
        Debug.Log("Fim.");
        actionQuery.Dispose();

        return "Up";
    }
}
