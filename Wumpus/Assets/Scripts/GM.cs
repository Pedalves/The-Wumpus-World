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

            Environment.SetEnvironmentVariable("SWI_HOME_DIR", @"C:\Program Files (x86)\swipl");
            Environment.SetEnvironmentVariable("Path", Environment.GetEnvironmentVariable("Path") + @";C:\Program Files (x86)\swipl;C:\Program Files (x86)\swipl\bin");
            if (!PlEngine.IsInitialized)
            {
                TextAsset textAsset = Resources.Load("wumpus") as TextAsset;
                Debug.Log(textAsset);
                Debug.Log("Path:");
                Debug.Log(Application.dataPath + "/Resources/wumpus.pl");
                String[] param = { "-q", "-f", Application.dataPath + "/Resources/wumpus.pl" };
                PlEngine.Initialize(param);
                PlQuery.PlCall("assert(start:-format('zvsf'))");
                PlQuery c = new PlQuery("start");
                c.NextSolution();
                //getNextAction();
            }
        }
    }

    // Use this for initialization
    void Start ()
    {
        _gameRunning = true;	
	}

    private void Update()
    {
        PointsText.text = "Points: " + GetAgent().Points;
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

    public string getNextAction()
    {
        PlQuery actionQuery = new PlQuery("move_up");
        actionQuery.NextSolution();
        foreach (PlQueryVariables v in actionQuery.SolutionVariables)
            Console.WriteLine(v["X"].ToString());

        return "";
    }
}
